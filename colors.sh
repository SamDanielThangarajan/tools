#!/usr/bin/env bash

. $TOOLS/common.sh

# Create an alternate screen
enter_alt_screen

function exit_pgm() {
   rm -rf .col.tmp >& /dev/null
   exit_restore_screen
}
trap exit_pgm INT

function show_colors() {
   rm -rf $1 2>/dev/null
   str="\\x1b[38;5;m"
   j=0
   for i in {0..254} ; do
      printf "\x1b[38;5;${i}mcolor${i} " >> $1
      j=$(($j + 1 ))
      [[ $j -eq 5 ]] && j=0 && printf "\n" >> $1
   done
}

show_colors .col.tmp
cat .col.tmp | column -t

read_escape_cmd && exit_pgm
