#!/usr/bin/env python3

import subprocess

my_command = ["cat", "small_accession_test.txt", "|", "efetch", "-db", "protein", "-format", "docsum"]

subprocess.run(my_command)
result = subprocess.run(my_command, capture_output=True, text=True)
output = result.stdout

