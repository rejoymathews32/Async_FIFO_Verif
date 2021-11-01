# !/usr/bin/python

import os
import re

# Add files in sim and rtl to the search path
rtl_path = "../../rtl/"
sim_path = "../../sim/"

#Add these to files.f
with open('files.f', "w") as compile_file:

    for root, dirs, files in os.walk(rtl_path):
        for file in files:
            # Dont add temp files
            if(not(re.search("[~#]", os.path.abspath(os.path.join(root, file))))):
                compile_file.write(os.path.abspath(os.path.join(root, file)))
                compile_file.write('\n')

    for root, dirs, files in os.walk(sim_path):
        for file in files:
            # Dont add temp files or files in the compile directory
            if(not(re.search("[~#]", os.path.abspath(os.path.join(root, file))))
            and not(re.search("compile", os.path.abspath(os.path.join(root, file))))):

                compile_file.write(os.path.abspath(os.path.join(root, file)))
                compile_file.write('\n')

compile_file.close()            