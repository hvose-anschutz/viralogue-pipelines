#!/usr/bin/env python3

import subprocess

my_link = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=Q8NCN2.4&retmode=xml&rettype=docsum"
my_old_filename = "efetch.fcgi?db=protein&id=Q8NCN2.4&retmode=xml&rettype=docsum"
my_accession = None

my_command = ["wget", my_link]

subprocess.run(my_command)

my_rename = ["mv", my_old_filename, "my_accessed_file.txt"]

subprocess.run(my_rename)

with open("my_accessed_file.txt", "r") as f:
    my_accession = f.readlines()
f.close()

if my_accession is not None:
    print("we downloaded something!")
    print(len(my_accession))