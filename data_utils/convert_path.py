#!/usr/bin/env python

import re
import sys

pattern = re.compile("^\D*?(\-?\d+)\D*?(\-?\d+)\D*$")

if __name__ == "__main__":
    in_file = sys.argv[1]

    with open(in_file, 'r') as f:
        for line in f:
            match = re.search(pattern, line)
            if match == None:
                print("NO MATCH!!!")
                sys.exit(1)
            print("[{}, {}],".format(match.group(1), match.group(2)))
