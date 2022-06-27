#!/usr/bin/env python3

import commands
import os
from subprocess import call

EDITOR = os.environ.get('EDITOR','vim') #that easy!

modified_op = commands.getstatusoutput(
        'git status --u=no | grep modified: | awk \'{print $2}\'')

new_files_op = commands.getstatusoutput(
        'git status --u=no | grep \"new file:\" | awk \'{print $3}\'')

list_of_files=[]
if modified_op[0] == 0:
    list_of_files.extend(modified_op[1].split('\n'))

if new_files_op[0] == 0:
    list_of_files.extend(new_files_op[1].split('\n'))

#Display
count = 0

print ('')
for file in list_of_files:
    print ('[' + str(count) + '] ' + file)
    count = count + 1


while True:
    print ('')
    selection = input('Select the file: ')

    print ('')
    print ('Opening ' + list_of_files[selection])

    print ('')
    confirm = raw_input("Continue y/n : ")

    if confirm.lower() == 'y' or confirm.lower() == 'yes':
        call ([EDITOR, list_of_files[selection]])
        break

    continue
