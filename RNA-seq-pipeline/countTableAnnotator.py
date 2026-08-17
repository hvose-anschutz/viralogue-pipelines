#!/usr/bin/env python3

"""Annotates an inputted count table by comparing
IDs to a provided reference file (Hsap/Mmus)"""

import re
import sys

ANNOTATION_REF = {}
experiment_index = {}

with open(sys.argv[2],"r",encoding="utf-8") as annot:
    for line in annot:
        my_line = line.strip().split("\t")
        ANNOTATION_REF[my_line[0]] = my_line[15]

with open(sys.argv[1],"r",encoding="utf-8") as f, open(sys.argv[3],"w",encoding="utf-8") as out:
    for idx, line in enumerate(f):
        my_line = line.strip().split("\t")
        if idx == 0:
            print(my_line[8:])
            total_samples = float(len(my_line[8:]))
            ### IF YOUR HEADER LINE IS DIFFERENT, CHANGE THIS
            ### Currently not set up to handle auto-processing
            for experiment_idx, exp in enumerate(my_line[8:]):
                exp = re.sub(r".+/TagDirectory/","",exp)
                #print(f"adding {exp} at {experiment_idx}")
                experiment_index[experiment_idx+8] = exp
            my_line.append("total_sum")
            my_line.append("average")
            my_line.append("fam_annotation")
            header = "\t".join(my_line)
            out.write(f"{my_line}\n")
        else:
            total_count = 0
            for count in my_line[8:]:
                total_count += float(count)
            total_avg = total_count / total_samples

            try:
                my_annotation = ANNOTATION_REF[my_line[0]]
            except KeyError as e:
                print(f"no annotation found for id {my_line[0]}")
                my_annotation = "NO ANNOTATION"

            my_line.append(str(total_count))
            my_line.append(str(total_avg))
            my_line.append(my_annotation)
            new_line = "\t".join(my_line)
            out.write(f"{new_line}\n")

print("FINISHED PROCESSING MAIN FILE")
