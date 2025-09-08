#!/usr/bin/env python3
import sys
import subprocess
import re

print("we started the file")

all_nr_files = sys.argv[1]
decider = int(sys.argv[2]) - 1
num_jobs = int(sys.argv[3])

my_groups = {}
my_accessions = []
my_title = None
my_id = None

with open("/scratch/alpine/hvose@xsede.org/all_nr_files.txt", "r") as nr:
    all_files = nr.readlines()
nr.close()

for i in range(len(all_files)):
    print("checking entry " + all_files[i])
    my_file = "/scratch/alpine/hvose@xsede.org/Outputs/KaseyOutputs/" + all_files[i].strip()
    my_suffix = all_files[i][0:4]
    if i%num_jobs == decider:
        with open(my_file, "r") as f:
            all_lines = f.readlines()
        f.close()
        
        for item in all_lines:
            my_line = item.strip().split("\t")
            my_accessions.append(my_line[1])
        
        unique_accessions = list(set(my_accessions))
        
        #BATCH THE DATA
        for dex in range(0, len(unique_accessions), 100):
            if (len(unique_accessions)-dex) < 100:
                my_accession = ",".join(unique_accessions[dex:len(unique_accessions)])
            else:
                my_accession = ",".join(unique_accessions[dex:dex+100])
        
            my_command = ["efetch", "-db", "protein", "-id", my_accession, "-format", "docsum"]
            result = subprocess.run(my_command, capture_output=True, text=True)
            output = result.stdout
            
            my_temp = "/scratch/alpine/hvose@xsede.org/temp_xml_" + my_suffix + ".txt"
            
            with open(my_temp, "w") as final:
                final.write(output)
            final.close()
            
            with open(my_temp, "r") as g:
                my_title = None
                my_id = None
                for line in g.readlines():
                
                    check_title = re.search("(<Title>)(.+)(<)", line)
                    check_id = re.search("(Version>)(.+)(<)", line)
                    check_end = re.search("</Document", line)
                    
                    if check_title is not None:
                        my_title = check_title.group(2)
                    
                    if check_id is not None:
                        my_id = check_id.group(2)
                            
                    if (my_id is not None) and (my_title is not None):
                        my_groups[my_id] = my_title
                        my_id = None
                        my_title = None
            
            g.close()
            
            if (my_id is not None) and (my_title is not None):
                my_groups[my_id] = my_title
                
        my_new_file = "/scratch/alpine/hvose@xsede.org/Outputs/KaseyOutputs/annotated_" + my_suffix + ".txt"
           
        with open(my_new_file,"w") as out: 
            for keys, values in my_groups.items():
                out.write("key: " + str(keys) + "\t" + " value: " + str(values) + "\n")

        out.close()
    
    

