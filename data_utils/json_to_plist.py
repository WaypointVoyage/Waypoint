#!/usr/bin/env python

import os
import sys

THIS_DIR = os.getcwd()

HELP_TEXT = \
"""
Usage: json_to_plist.py DATA_TYPE

    DATA_TYPE: the kind of data to convert (ie 'levels')

"""

def convert(json_file, plist_file):
    print("converting {} to {}".format(os.path.split(json_file)[1], \
        os.path.split(plist_file)[1]))
    cmd = "plutil -convert xml1 {} -o {}".format(json_file, plist_file)
    os.system(cmd)

def convert_dir(json_dir, plist_dir):
    for filename in os.listdir(json_dir):
        if filename.endswith(".json"):
            json_path = os.path.join(json_dir, filename)
            plist_path = os.path.join(plist_dir, filename[:-5] + ".plist")
            convert(json_path, plist_path)

if __name__ == "__main__":

    if len(sys.argv) < 2 or sys.argv[1] in ["help", "-h"]:
        print(HELP_TEXT)
        sys.exit(0)

    the_type = sys.argv[1]
    JSON_DIR = os.path.join(THIS_DIR, "{}_json".format(the_type))
    PLIST_DIR = os.path.join(THIS_DIR, "{}_plist".format(the_type))
    for directory in [PLIST_DIR, JSON_DIR]:
        if not os.path.exists(directory):
            os.makedirs(directory)

    convert_dir(JSON_DIR, PLIST_DIR)
