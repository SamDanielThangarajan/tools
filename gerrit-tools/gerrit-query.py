#!/usr/bin/python

import json
#from pprint import pprint
import os
import sys
from optparse import OptionParser
#from StringIO import StringIO

options_m=''

def execute(cmd):
    if os.system(cmd):
        print cmd, 'failed!'

def list_open_changes():
    cmd = 'ssh -p ' + options_m.port + ' ' + options_m.server + ' gerrit query --format=JSON --current-patch-set --patch-sets status:'+options_m.status+ ' project:' + options_m.project +'  > gerrit_query.op.tmp'
    #print cmd
    execute(cmd)

    print ''
    with open('gerrit_query.op.tmp') as json_file:
        for content in json_file:
            data = json.loads(content)

            #print json.dumps(data, sort_keys=True, indent=4, separators=(',', ': '))

            try:
                if options_m.author is None or options_m.author == data['owner']['name']:
                    print 'Title         : ' + data['subject']
                    print 'Change-id     : ' + data['id']
                    print 'Owner         : ' + data['owner']['name']
                    print 'Status        : ' + data['status']
                    print 'url           : ' + data['url']
                    print 'Current patch : ' + data['currentPatchSet']['ref']
                    print ''

            except:
                pass
    
    execute('rm -rf gerrit_query.op.tmp')

def processOptions(args):
    global options_m
    global port_m
    global server_m

    parser = OptionParser()
    parser.add_option("-p", "--project", action="store", type="string", dest="project",\
            metavar="PROJECT", help="The project in gerrit server")
    parser.add_option("-P", "--port", action="store", type="string", dest="port",\
            metavar="PORT", help="The gerrit server port")
    parser.add_option("-S", "--server", action="store", type="string", dest="server",\
            metavar="SERVER", help="the gerrit server")
    parser.add_option("-s", "--status", action="store", type="string", dest="status",\
            metavar="STATUS", help="draft|open|closed|merged")
    parser.add_option("-a", "--author", action="store", type="string", dest="author",\
            metavar="AUTHOR", help="Author Name")
    (options_m, args) = parser.parse_args(args)
    """ TODO : check the options """

def main(args):
    processOptions(args)
    list_open_changes()


if __name__ == '__main__':
    main(sys.argv[1:])

