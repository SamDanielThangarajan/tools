#!usr/bin/env python
#Python script to find file form ctags.

import socket
import sys
import os
import re
from optparse import OptionParser
import getpass
import errno

#Global variables
optionsM=''

#utility functions
#x is the return code
def printusageandexit(x):
  print "findfile [c|h|java] --file filename"
  exit(x)

def getHostName():
  return socket.gethostname()

def error(arg):
  print 'ERROR! ', arg
  exit(1)

def cmd(cmd):
  if os.system(cmd):
    error('Command Failed:' + cmd)

def processOptions(args):
  global optionsM
  parser = OptionParser()
  parser.add_option("", "--source", action="store", type="string", dest="source")
  parser.add_option("", "--header", action="store", type="string", dest="header")
  parser.add_option("-j", "--java", action="store", type="string", dest="java")
  parser.add_option("-f", "--file", action="store", type="string", dest="file")
  parser.add_option("-c", "--clone", action="store", type="string", dest="clone_name")
  parser.add_option("-p", "--project", action="store", type="string", dest="project_name")
  (optionsM, args) = parser.parse_args(args)
  if not optionsM.file:
    printusageandexit(1)
  if not optionsM.clone_name:
      optionsM.clone_name = os.environ['CLONE_NAME']
  if not optionsM.project_name:
      optionsM.project_name = os.environ['PROJECT_NAME']



def getTagFile(project,clone):
  tag_file=os.environ['HOME'] + '/project_tags/' + project + '/' + clone + '/tags'
  return tag_file

def findFile():
  global optionsM
  output = set()
  for line in open(getTagFile(optionsM.project_name,optionsM.clone_name)):
    #filepath = line.split()
    filename_arr = line.split()[1].split('/')
    filename_arr.reverse()
    filename = filename_arr[0]

    '''match with filename'''
   # if optionsM.file in filename:
    '''add the file path'''  
   #   output.add(line.split()[1])

    match = re.search(optionsM.file,filename,re.IGNORECASE)
    if match:
        output.add(line.split()[1])
  
  for file in output:
      print file


''' Funtion to get the list of files 
This function can be used by other python code to
get the list of files to be processed'''
def getFileList(project,clone):
    output = set()
    for line in open(getTagFile(project,clone)):
        output.add(line.split()[1])
    return output

def main(argv):
  processOptions(argv)
  findFile()
  exit (0)
	
if __name__ == '__main__':
  main(sys.argv[1:])

	
