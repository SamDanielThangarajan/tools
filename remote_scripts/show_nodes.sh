#!/usr/bin/env bash

# Create an alternate screen
tput smcup

function restore_screen() {
   rm -rf .sn.tmp
   tput rmcup
   exit 0
}
trap restore_screen INT

function show_nodes() {
   #Show nodes
   # newline is replaced by |.
   echo "ALIAS NODE USER" > $1
   echo "***** ***** *****" >> $1
   while read line
   do
      [[ $line =~ ^# ]] && continue
      token_count=$(echo $line | wc -w)
      [[ $token_count -ne 4 ]] && continue

      alias=$(echo $line | awk '{print $1}')
      node=$(echo $line | awk '{print $2}')
      user=$(echo $line | awk '{print $3}')

      echo -e "" >> $1
      echo -e "$alias $node $user" >> $1
   done<~/nodes.cfg
}

rm -rf .sn.tmp
show_nodes .sn.tmp

cat .sn.tmp | column -t

# Escape
while true
do
   read -n 1 var
   [[ $var = 'q' ]] && restore_screen && exit 0
done
