#!/usr/bin/env bash

# Create an alternate screen
tput smcup

function restore_screen() {
   rm -rf .sn.tmp 2>/dev/null
   tput rmcup
   exit 0
}
trap restore_screen INT

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
while true
do
   read -n 1 var
   [[ $var = 'q' ]] && restore_screen
done
