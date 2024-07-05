#!/usr/bin/python

import argparse
import os
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description="find source files and list them to stdout, assigning a unique integer to each")
    parser.add_argument('--root_dir', help='root of your project', required="True")
    parser.add_argument('--max_files', type = int, help='maxiumum number of source files', required=True)
    parser.add_argument('--max_lines', type = int, help='maxiumum number of lines in any source file', required=True)

    args = parser.parse_args()
    os.chdir(args.root_dir)
    max_files = args.max_files
    max_lines = args.max_lines

    source_exts = [ '*.c', '*.cpp' ]

    srcs = list()
    for se in source_exts:
        sl = list(p for p in Path('.').rglob(se))
        srcs += sl

    n_files = len(srcs)
    if n_files > max_files:
        print("too many source files ({}, max is {})".format(n_files, max_files))
        exit(-1)
    else:
        print("{} src files found".format(n_files))

    output = list()
    file_code = 0 
    longest_length = 0 
    longest_file = None
    srcs = sorted(srcs)
    for p in srcs:
        num_lines = sum(1 for line in open(p))
        if num_lines > longest_length:
            longest_length = num_lines
            longest_file = p.name
        if num_lines > max_lines:
            print("file {} is too long ({} lines)".format(p.name, num_lines))
            exit(-1)
        file_code += 1
        output.append("{}\t{}".format(file_code, p))
    # output.append("longest file {} has {} lines".format(longest_file, longest_length))

    print( "\n".join(output) )

if __name__ == "__main__":
    main()
