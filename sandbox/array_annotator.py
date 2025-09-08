#!/usr/bin/env python3

import subprocess
import re
import time
import sys

print("file started")

#supposedly this won't get me banned

access_file = "unique_accessions.txt"
my_groups = {}
my_title = None
my_id = None
starter = int(sys.argv[1]) - 1

with open(access_file, "r") as f:
    my_list = f.readlines()
f.close()

if starter+60000 > len(my_list):
    end = len(my_list)
else:
    end = starter*60000 + 60000

for item in range(starter*60000,end,100):
    if len(my_list) - item < 100:
        pruned = [s.replace('\n', '') for s in my_list[item:len(my_list)]]
        add_to_link = ",".join(pruned)
    else:
        pruned = [s.replace('\n', '') for s in my_list[item:item+100]]
        add_to_link = ",".join(pruned)
    
    print("processing chunk " + str(item))

    my_command = ["efetch", "-db", "protein", "-id", add_to_link, "-format", "docsum"]
    result = subprocess.run(my_command, capture_output=True, text=True)
    output = result.stdout
    time.sleep(1)

    output_list = output.split("\n")

    for line in output_list:
        print("checking line: " + line)
        check_title = re.search("(Title>)(.+)(<)", line)
        check_id = re.search("(Version>)(.+)(<)", line)
            
        if check_title is not None:
            my_title = check_title.group(2)
                
        if check_id is not None:
            my_id = check_id.group(2)
                        
        if (my_id is not None) and (my_title is not None):
            print("added a thing to the dictionary")
            my_groups[my_id] = my_title
            my_id = None
            my_title = None
        
    if (my_id is not None) and (my_title is not None):
        print("added a thing to the dictionary")
        my_groups[my_id] = my_title

outfile = "all_values_" + str(starter) + ".txt"

with open(outfile, "w") as final:
    for key in my_list:
        check_key = key.strip()
        if check_key in my_groups.keys():
            final.write(check_key + "\t" + my_groups[check_key] + "\n")
            del my_groups[check_key]
        else:
            final.write(check_key + "\t" + "NO DATA ACCESSED" + "\n")
    
    final.write("\n")
    final.write("ALL OTHER ACCESSIONS FOUND\n")

    for key, value in my_groups.items():
        final.write(key + "\t" + value + "\n")

final.close()

print("all done!")