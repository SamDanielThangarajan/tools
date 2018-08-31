#!/usr/bin/env bash

. $TOOLS/common.sh

# Create an alternate screen
enter_alt_screen

function exit_pgm() {
   rm -rf .sn.tmp >& /dev/null
   exit_restore_screen
}
trap exit_pgm INT

function show_nodes() {
   echo "ALIAS NODE USER"  > $1
   echo "***** ***** *****" >> $1
   while read line
   do
      [[ $(echo $line | wc -w) -ne 4 ]] && continue
      echo -e "" >> $1
      echo $line | awk '{print $1 " " $2 " " $3}' >> $1
   done<~/nodes.cfg
}

show_nodes .sn.tmp
cat .sn.tmp | column -t

# Escape
read_escape_cmd && exit_pgm
