#!/usr/bin/env python

import os
import sys

THIS_DIR = os.getcwd()
JSON_DIR = os.path.join(THIS_DIR, "json")
PLIST_DIR = os.path.join(THIS_DIR, "plist")

HELP_TEXT = \
"""
Usage: make_levels.py FILE_NAME

    FILE_NAME: the optional json file to convert to a .plist

    If no FILE_NAME is specified, .json files in
        {}
    are converted to .plist and put into
        {}
""".format(JSON_DIR, PLIST_DIR)

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
    single_file = None

    if len(sys.argv) > 1:
        if sys.argv[1] in ["help", "-h"]:
            print(HELP_TEXT)
            sys.exit(0)
        else:
            single_file = os.path.join(JSON_DIR, sys.argv[1] + ".json")

    for directory in [PLIST_DIR, JSON_DIR]:
        if not os.path.exists(directory):
            os.makedirs(directory)

    if single_file is not None and os.path.exists(single_file):
        plist_file = os.path.join(PLIST_DIR, sys.argv[1] + ".plist")
        convert(single_file, plist_file)
    else:
        convert_dir(JSON_DIR, PLIST_DIR)
