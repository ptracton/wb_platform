#! /usr/bin/env python3

"""
clean_up.py

Clean up the simulation environment byproduct files
"""

import argparse
import json
import os
import sys

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Run FPGA Simulation')
    parser.add_argument("-D", "--debug",
                        help="Debug this script",
                        action="store_true")
    

    args = parser.parse_args()
    if args.debug:
        print(args)

    configurations_dir = "../configurations/"
    json_file_list = os.listdir(configurations_dir)
    print (json_file_list)
    for json_file in json_file_list:
        print("Cleaning {}".format(json_file))
        if json_file.split(".")[1] == "json":            
            try:
                f = open(configurations_dir+json_file, "r")
                json_data = json.load(f)
            except:
                print("Failed to open %s" % (json_file))
                sys.exit(-1)

            remove_file_string = json_data.get('remove_files')            
            if (remove_file_string is not None):
                command = "rm -rf %s" % remove_file_string
                print (command)
                os.system(command)
