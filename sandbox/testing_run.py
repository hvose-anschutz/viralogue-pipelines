#!/usr/bin/env python3
import subprocess

accession = 'BAG63669.1'

my_command = ["efetch", "-db", "protein", "-id", accession, "-format", "xml"]

result = subprocess.run(my_command, stdout=subprocess.PIPE)

with open("my_xml_data.txt", "wb") as f:
    f.write(result.stdout)
    
f.close()