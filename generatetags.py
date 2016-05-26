
#Python script to generate ctags.

import socket
import sys
import os
from optparse import OptionParser
import getpass
import errno
import findFileinclone
import os.path

#Global variables
optionsM=''
clone_pathM=''
tag_fileM=''
cscope_dbM=''

#utility functions
#x is the return code
def printusageandexit(x):
  print "generatetags.py <-p|--project projectName> <-c|--clone cloneName>"
  exit(x)

def getHostName():
  return socket.gethostname()

def error(arg):
  print 'ERROR! ', arg
  exit(1)

def cmd(cmd):
    errno = os.system(cmd)
    if errno:
        error('Command Failed [' + str(errno) + ']:' + cmd)

def verifyClone():
  global clone_pathM
  #clone_pathM = '/project/EAB3_EMC/LM/' + getpass.getuser() + '/' + optionsM.clone_name
  clone_pathM = '/repo/' + optionsM.project_name  + '/' + optionsM.clone_name
  if not os.path.exists(clone_pathM):
    error('clone does not exist')

def processOptions(args):
  global optionsM
  parser = OptionParser()
  parser.add_option("-c", "--clone", action="store", type="string", dest="clone_name")
  parser.add_option("-p", "--project", action="store", type="string", dest="project_name")
  (optionsM, args) = parser.parse_args(args)
  if not optionsM.clone_name or not optionsM.project_name:
    printusageandexit(1)

def createDirectoryForIndexFiles():
  global tag_fileM
  global cscope_dbM
  directory = '/home/' + getpass.getuser() + '/project_tags/' + optionsM.project_name  + '/' + optionsM.clone_name + '/'
  tag_fileM=directory + 'tags'
  cscope_dbM = directory + 'cscope.out'
  try:
    os.makedirs(os.path.dirname(tag_fileM))
  except OSError, e:
    if errno.EEXIST != e.errno:
      raise e
    pass

def generateTags():
  print getHostName(), ": generating ctags for clone " ,  optionsM.clone_name  
  exclude_list='--exclude=boost* --exclude=gmock* --exclude=poco* --exclude=thrift-* --exclude=maf*'
  #TODO : removed --language-force=C++ from below command
  ctags_cmd = '/usr/bin/ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q ' + exclude_list +' -f ' + tag_fileM + ' ' + clone_pathM
  cmd(ctags_cmd)
  print getHostName(), ": generating ctags for clone " ,  optionsM.clone_name + ' ...done' 

def generateCscopeDb():
    print getHostName(), ": generating cscope db for clone " ,  optionsM.clone_name  
    filelist = findFileinclone.getFileList(optionsM.project_name,optionsM.clone_name)
    files = ' '
    f = open('filelist','w')
    for file1 in filelist:
        if os.path.isfile(file1) and not os.path.islink(file1):
            f.write(file1.rstrip())
            f.write('\n')
    f.close()        
    cscope_cmd = '/usr/bin/cscope -b -f ' + cscope_dbM + ' -i filelist'  
    cmd(cscope_cmd)
    os.remove('filelist')
    print getHostName(), ": generating cscope db for clone " ,  optionsM.clone_name + ' ...done' 


def main(argv):
  processOptions(argv)
  verifyClone()
  createDirectoryForIndexFiles()
  generateTags()
  generateCscopeDb()
  exit (0)
	
if __name__ == '__main__':
  main(sys.argv[1:])

	
