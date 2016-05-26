#!/usr/bin/python

import sys
import os
import errno
import os.path
import re

tmp_file_g = './.file.tree'

def error(arg):
  print 'ERROR! ', arg
  exit(1)

def cmd(cmd):
    errno = os.system(cmd)
    if errno:
        error('Command Failed [' + str(errno) + ']:' + cmd)

def clean_tmp_file():
    if os.path.exists(tmp_file_g):
        os.remove(tmp_file_g)

def collect_commits(start,end):

    clean_tmp_file()

    cmd_str = "git log --date=short --graph --abbrev-commit --decorate --format=format:'%h (%cd) - %s - %cn'"
    cmd_str = cmd_str + " --skip=" + str(start)
    cmd_str = cmd_str + " -n " + str(end)
    cmd_str = cmd_str + " > " + tmp_file_g
    cmd(cmd_str)

    has_commit = re.compile('^\*')
    is_diverged = re.compile('^\|/')

    for line in open(tmp_file_g):
        if has_commit.match(line):
            line1 = re.sub('^[\W]+', '', line)
            print line1
        elif is_diverged.match(line):
                return 1
            
    return 0

def main(argv):

    skip = 0
    count = 100
    while (1):
        if collect_commits(skip,count):
            break
        else:
            skip = skip + count

    clean_tmp_file()
	
if __name__ == '__main__':
  main(sys.argv[1:])

	
