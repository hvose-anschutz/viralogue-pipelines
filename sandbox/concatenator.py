#!/usr/bin/env python3

import re

valid_matches = {}
original_valid = []
invalid_matches = {}
original_invalid = []
check_other = False

for i in range(0,10):
	check_other = False
	file_to_parse = "all_values_" + str(i) + ".txt"
	with open(file_to_parse, "r") as f:
		for myline in f.readlines():
			line = str(myline)
			check_access = re.search("NO DATA ACCESSED", line)
			other_flag = re.search("ALL OTHER", line)
			if other_flag is not None:
			    check_other = True
			if check_access is None:
				protein_info = line.strip().split("\t")
				#print(protein_info)
				if check_other == False:
				    if len(protein_info) > 1:
					    valid_matches[protein_info[0]] = protein_info[1]
				else:
				    if len(protein_info) > 1:
					    invalid_matches[protein_info[0]] = protein_info[1]
	f.close()

with open("all_accessions.txt", "w") as g:
    for key, value in valid_matches.items():
        g.write(key + "\t" + value + "\n")
        
    g.write("BAD ACCESSIONS\n")
    
    for bad_key, bad_value in invalid_matches.items():
        g.write(bad_key + "\t" + bad_value + "\n")
            
g.close()