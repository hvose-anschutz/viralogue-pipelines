#!/usr/bin/env python3

import glob
import io
import os
import sys
import subprocess
import time
from pathlib import Path

### GLOBAL FUNCTIONS
def run_command(
    cmd:list,
    step:str,
    cap_out:bool=False,
    check_state:bool=False,
    stdin_redirect:None|io.BufferedWriter=None,
    stdout_redirect:io.TextIOWrapper|None=None,
    extra_error:str|None=None
) -> bool:
    """Runs a subprocess command. Returns True if the run was successful, and false otherwise."""
    try:
        subprocess.run(cmd,
                        stdin=stdin_redirect,
                        stdout=stdout_redirect,
                        check=check_state,
                        capture_output=cap_out)
        return True
    except subprocess.CalledProcessError as run_error:
        print(run_error,f"failed at {step}")
        if extra_error is not None:
            print(extra_error)
        return False



class SampleAccession:
    """Class to contain sample accession paths and methods."""

    #GET WAY TO SET AUTOMATICALLY
    BASE = Path(os.path.expandvars('/scratch/alpine/$USER'))
    DIR = Path(os.path.expandvars('/scratch/alpine/$USER/c_albicans_benchmark')) 

    def __init__(self, acc, n_cores, b_filter, overwrite:bool=False):
        self._accession: str = acc
        self._paired = False
        self.fq = []
        self.bloom_filter = b_filter
        self.bloom_prefix = str(self.DIR) + '/' + self._accession + "_out"
        self.bloom_out = []
        self.final_contigs = Path(self.DIR / self._accession / "final.contigs.fa")
        self.cores = n_cores
        self.overwrite = overwrite

    @property
    def accession(self):
        return self._accession

    @property
    def paired(self):
        return self._paired
    
    @paired.setter
    def paired(self,value:bool):
        self._paired = value

    def init_file_check(self):
    # check file existence 
        if self.final_contigs.is_file():
            if self.overwrite:
                print("final contigs file found, overwriting files...")
                self.delete_files(delete_step="pipeline_overwrite",
                                    glob_accession=True,
                                    delete_dirs=True)
            else:
                print(f"final contigs file found, skipping {self._accession}")
                return True
        return False
    
    def _add_files(self,
                 files: list|str,
                 list_to_add: list) -> None:
        """Adds a file to a provided list. Should only be used on self list
        objects such as fq or bloom_out."""
        if type(files) is list:
            for added_file in files:
                list_to_add.append(added_file)
        else:
            list_to_add.append(files)
        return None

    def get_files(self,
                fq_list:list|None=None):
        "Returns the contents of self-attribute file lists. Automatically"
        "assess for paired-end status."
        if self.paired:
            return fq_list[0],fq_list[1]
        else:
            return fq_list[0]

    def _check_file_exists(self,
        prefix:str,
        ending:str="",
        list_to_add:list|None=None) -> bool:
        """Checks if the given accession is single or paired end, and checks if the files exist.
        Requires built-in continue logic if neither file exists but sra_run is True.
        Will exit unless an iterator is provided."""


        # Define the directory and the prefix you want to match
        files = [f for f in self.DIR.glob(f"{prefix}*{ending}") if f.is_file()]

        if len(files) > 2:
            print(f"Deleting all files associated with sample {self._accession}")
            self._delete_files(delete_step="Removing Failed Run Contents",
            glob_accession=True,
            delete_dirs=True)
            return False
            
        if len(files) == 2:
            self.paired = True
            self._add_files(files,list_to_add)
        
        elif len(files) == 1:
            self._add_files(files,list_to_add)
            
        else:
            print(f"No files found on disk.")
            return False

        return True

    def _delete_files(self,
                    delete_step:str,
                    files_to_delete:list|str=[],
                    glob_accession:bool=False,
                    delete_dirs:bool=False,
                    cmd_override:list|None=None) -> bool|None: 
        """Deletes files provided in list or str format. Will exit loop unless iterator
        is provided."""
        if cmd_override is not None:
            print("WARNING! Using command override. Assuming defaults for run_command.")
            rm_run = run_command(cmd_override,
                                step=delete_step,
                                check_state=True,
                                extra_error=f"WARNING: Failed at {delete_step}. \
                                Accumulation of files may cause unwanted IO/server errors.")
            
        if glob_accession:
            #TODO: include prefix option so _accession isn't default
            files_to_delete = [f for f in self.DIR.glob(f"{self._accession}*") if f.is_file()]
        if delete_dirs:
            rm_base = ["rm","-r"]
        else:
            rm_base = ["rm"]
        if type(files_to_delete) is list:
            rm_cmd = rm_base + files_to_delete
        else:
            rm_cmd = rm_base.append(files_to_delete)

        rm_run = run_command(rm_cmd,
                    step=delete_step,
                    check_state=True,
                    extra_error=f"WARNING: Failed at {delete_step}. \
                    Accumulation of files may cause unwanted IO/server errors.")

        return rm_run

    ### PIPELINE STEPS ###

    def _sra_dump(self) -> None|int:
        sra_cmd = ['fasterq-dump',self.accession,'--split-files','-e',str(self.cores),'-O',self.DIR]

        sra_run = run_command(
            sra_cmd,
            step="SRADump",
            check_state=True,
            extra_error=f"SRADump could not be completed, see specific error for more details.")
        
        self._check_file_exists(prefix=self._accession,
                                ending=".fastq",
                                list_to_add=self.fq)

        return sra_run

    def _bloom_filter(self):
        """Filters samples based on provided bloom filter reference."""
        if self.paired:
            fq_1, fq_2 = self.get_files(self.fq)
            item_bloom_1 = Path(str(self.DIR) + '/' + self._accession + "_outnoMatch_1.fq")
            item_bloom_2 = Path(str(self.DIR) + '/' + self._accession + "_outnoMatch_2.fq")
            self._add_files(files=[item_bloom_1,item_bloom_2],
                           list_to_add=self.bloom_out)
            bloom_cmd = [
                "biobloomcategorizer",
                "-d",
                "-n",
                "-t",
                str(self.cores),
                "-e",
                "-p",
                self.bloom_prefix,
                "-f",
                self.bloom_filter,
                fq_1,
                fq_2
                ]
                
            print(f"passing command: {bloom_cmd}")    

            #command to split single stdout stream into two noMatch files
            awk_cmd = [
                "awk",
                "-v",
                f"out1={item_bloom_1}",
                "-v",
                f"out2={item_bloom_2}",
                '{print > (int((NR-1)/4)%2==0 ? out1 : out2)}'
            ]

            try:
                with subprocess.Popen(
                    bloom_cmd,
                    stdout=subprocess.PIPE
                ) as bf_out:

                    bloom_run = run_command(awk_cmd,
                                cap_out=False,
                                check_state=True,
                                step="paired-end Bloom filtering",
                                stdin_redirect=bf_out.stdout,
                                extra_error=self._accession
                                )

                    bf_out.stdout.close()

                    return_code = bf_out.wait()

                    if (return_code != 0) or (not bloom_run):

                        print(f"{self.accession} failed with exit code {return_code}")
                        return False
                    return True
            except subprocess.CalledProcessError as e:
                print(f"Failed at separation of paired-end Bloom filters.", e, self._accession)
                return False

            
        else:
            fq_se = self.get_files(self.fq)
            item_bloom_se = Path(str(self.DIR) + '/' + self._accession + "_outnoMatch.fq")
            self._add_files(item_bloom_se,self.bloom_out)
            print(self.bloom_out)
            bloom_cmd = [
                    "biobloomcategorizer",
                    "-d",
                    "-n",
                    "-t",
                    str(self.cores),
                    "-p",
                    self.bloom_prefix,
                    "-f",
                    self.bloom_filter,
                    fq_se
                ]
            print(f"passing command {bloom_cmd}")    
                
            with open(self.bloom_out[0], "w") as f:
                se_bloom_run = run_command(bloom_cmd,
                step="single end Bloom filtering",
                check_state=True,
                stdout_redirect=f)
                return se_bloom_run
            
    def _bloom_threshold_check(self,thresh:float=0.20):
        tsv_file = Path(str(self.DIR) + "/" + self._accession + "_out_summary.tsv")
        with open(tsv_file,"r",encoding="utf-8") as summary:
            for line in summary:
                if "noMatch" in line:
                    nm_line = line.strip().split("\t")
                    print(f"{self._accession} noMatch rate: {nm_line[4]}")
                    if float(nm_line[4]) > thresh:
                        #deletes ALL files associated with the accession, will not touch folders in current state
                        rm_pattern = glob.glob(sample.DIR + self._accession + "*.*")
                        my_bloom_delete_cmd = ["rm"] + rm_pattern
                        print(f"Files to be deleted: {rm_pattern}")
                        bloom_thresh_delete =run_command(my_bloom_delete_cmd,
                                    step="Large Bloom Filter Deletion",
                                    check_state=True,
                                    extra_error=f"WARNING! Large noMatch files (over {thresh}%) could not be deleted.")
                        return bloom_thresh_delete
                    else:
                        return True

    def _megahit_assembly(self):
        """Runs the MEGAHIT assembly."""
        megahit_out = Path(str(self.DIR) + "/" + self._accession)
        if self._paired:
            mh_1, mh_2 = self.get_files(self.bloom_out)
            my_mh_cmd = [
                "megahit",
                "-1",mh_1,
                "-2",mh_2,
                "-t",str(self.cores),
                "-o",megahit_out
            ]
        else:
            mh_fq = self.get_files(self.bloom_out)
            my_mh_cmd = [
                "megahit",
                "-r",mh_fq,
                "-t",str(self.cores),
                "-o",megahit_out
            ]

        result_mh = run_command(
            my_mh_cmd,
            step="MEGAHIT assembly",
            cap_out=True,
            check_state=True
            )

        return result_mh


    def _delete_sra_cache(self):
        """Checks for valid SRA cache files and deletes the corresponding files to help save space.
        Should only be run after the entire pipeline is completed to avoid file I/O errors."""
        cache1 = Path(str(self.BASE) + "/sra/sra/" + self._accession + ".sra")
        cache2 = Path(str(self.BASE) + "/sra/sra/" + self._accession + ".sra.cache")
                    
        if not cache1.is_file() and not cache2.is_file():
            print("No SRA cache to delete.")
            pass
        else:
            if cache1.is_file():
                my_sra_cache_delete_cmd = ["rm", cache1]
            elif cache2.is_file():
                my_sra_cache_delete_cmd = ["rm", cache2]
            else:
                print("SRA cache not found")
            sra_cache_delete = run_command(my_sra_cache_delete_cmd,
                        step="SRA Cache Deletion",
                        check_state=True)

            return sra_cache_delete

    def _delete_folder_subcontents(self,dir_path:str|None=None,exclude:str="final.contigs.fa"):
        """Deletes subfolder contents generated by MEGAHIT."""
        if dir_path is None:
            dir_path = Path(str(self.DIR) + "/" + self._accession + "/.")
        my_mh_delete_cmd = [
            "find",
            dir_path,
            "-mindepth",
            "1",
            "-not",
            "-name",
            exclude,
            "-delete"
        ]
        mh_delete = run_command(my_mh_delete_cmd,
                                step="Megahit delete",
                                check_state=True)
        return mh_delete
        

    def pipeline_run(self,iter:int) -> int|Path:
        """Runs the pipeline."""
        contigs_exist = self.init_file_check()
        if contigs_exist:
            return iter + 1
            
        SRA_exists = self._check_file_exists(prefix=self._accession, ending=".fastq",list_to_add=self.fq)
        bloom_exists = self._check_file_exists(prefix=self._accession,ending="noMatch",list_to_add=self.bloom_out)
        
        
        print(f"STARTING RUN:")
        if not SRA_exists:
            start_sra = time.time()
            sra = self._sra_dump()
            if not sra:
                print(f"SRA failed in {time.time() - start_sra} seconds.")
                return iter + 1
            print(f"SRA completed in {time.time() - start_sra} seconds.")
        else:
            print("Found SRA file, continuing...")

        if not bloom_exists:
            start_bloom = time.time()
            bloom = self._bloom_filter()
            if not bloom:
                print(f"Bloom filtering failed in {time.time() - start_bloom} seconds.")
                return iter + 1
            
            bloom_thresh = self._bloom_threshold_check()
            print(f"bloom thresh: {bloom_thresh}")
            if not bloom_thresh:
                print(f"Bloom thresholding failed in {time.time() - start_bloom} seconds.")
                return iter + 1
            else:
                print(f"did we make it here???")
            sra_delete = self._delete_files("SRA FQ Delete",self.fq)
            if not sra_delete:
                return iter + 1
                
            print(f"Complete Bloom filtering and thresholding completed in {time.time() - start_bloom} seconds")
        else:
            print("Found bloom filtering files, continuing...")
        
        print("SRA Files deleted, continuing with MEGAHIT")

        start_megahit = time.time()
        megahit = self._megahit_assembly()
        if not megahit:
            print(f"MEGAHIT failed in {time.time() - start_megahit} seconds.")
            return iter + 1

        print(f"MEGAHIT completed in {time.time() - start_megahit} seconds.")
        cache_delete = self._delete_sra_cache()
        if not cache_delete:
            return iter + 1
        delete_mh_folder = self._delete_folder_subcontents()
        if not delete_mh_folder:
            return iter + 1
        delete_extraneous_files = self._delete_files("Bloom and summary delete",glob_accession=True)
        #concatenate??? incorporate later, not necessary right now
        return self.final_contigs



### MAKE THESE INTO ARGPARSE ARGUMENTS
sample_list = sys.argv[1]
catch = int(sys.argv[2]) - 1
num_jobs = int(sys.argv[3])
num_cores = int(sys.argv[4])
bloom_filter_reference = sys.argv[5]

with open(sample_list, 'r') as acc_list:
    j = 0
    for line in acc_list:
        if j % num_jobs == catch:
            ### MAKE PRINT STATEMENTS INTO VERBOSE OUTPUT AS PART OF ARGPARSE
            print(f"Number={j}. NumJobs={num_jobs}, Catch={catch}")
            print(f"{j%num_jobs}")

            line = line.rstrip('\n')
            array = line.split('\t')

            sample = SampleAccession(acc=array[0],
                                     n_cores=num_cores,
                                     b_filter=bloom_filter_reference)

            print(f"Now processing sample {sample.accession}\n")

            pipeline = sample.pipeline_run(j)  
            if type(pipeline) == int:
                j = pipeline
                continue  
            else:
                print(f"Pipeline part 1 complete: final.contigs.fa file stored at {pipeline}")       

        j += 1