#!/usr/bin/env python3
import sys
import subprocess
import re

print("we started the file")

#all_nr_files = sys.argv[1]
#decider = int(sys.argv[2]) - 1
#num_jobs = int(sys.argv[3])

my_groups = {}
my_accessions = []
my_title = None
my_id = None

with open("/scratch/alpine/hvose@xsede.org/all_nr_files.txt", "r") as nr:
    all_files = nr.readlines()

nr.close()

for i in all_files:
    my_file = "/scratch/alpine/hvose@xsede.org/Outputs/KaseyOutputs/" + i.strip()
    
    with open(my_file, "r") as f:
        all_lines = f.readlines()
    f.close()
    
    for item in all_lines:
        my_line = item.strip().split("\t")
        my_accessions.append(my_line[1])
    
    unique_accessions = list(set(my_accessions))
    
print("finished the uniqueness list")

with open("/scratch/alpine/hvose@xsede.org/unique_accessions.txt", "w") as g:
    for item in unique_accessions:
        g.write(item + "\n")

g.close()
    
