#!/usr/bin/env python3

#NOTES: you have to call module load python/3.10.2 because the default is 3.6
#additionally, you have to use subprocess.run because .call doesn't support new features

import subprocess
import sys
import re

#GLOBAL
my_temp_file = '/scratch/alpine/hvose@xsede.org/temp_xml.txt'

#GETS LIST OF ALL .NR FILES
with open(sys.argv[1], "r") as f: 
    all_nr_files = f.readlines():

#TAKES IN A .NR FILE
for nr_file in all_nr_files:
    open_file = '/scratch/alpine/hvose@xsede.org/Outputs/KaseyOutputs/' + nr_file
    with open(open_file, "r") as g:
        current_reads = g.readlines()
    g.close()
    
    #LOCAL DEFINITIONS (must be redefined per file)
    my_ncbi_data = {}
    
    #GENERATE LIST TO BATCH
    batch_list = []
    for line in current_reads:
        parsed_line = line.strip().split("\t")
        #print(parsed_line)
        batch_list.append(parsed_line[1])
    
    #BATCH THE DATA
    for dex in range(0, len(batch_list), 500):
        if (len(batch_list)-dex) < 500:
            my_accession = batch_list[dex:len(batch_list)]
        else:
            my_accession = batch_list[dex:dex+500]
    
        #SEND THE DATA TO NCBI AND WRITE TO TEMP   
        my_command = ["efetch", "-db", "protein", "-id", my_accession, "-format", "xml", "-retmax", "500"]
        result = subprocess.run(my_command, capture_output=True, text=True)
        output = result.stdout
        #print(output)
        with open(my_temp_file, "w") as final:
            final.write(output)
        final.close()
    
        #each accession is ordered, so we only need to find lineage and Seqdesc_title
        