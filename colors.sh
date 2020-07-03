#!/usr/bin/env bash

. $TOOLS/common.sh

declare -r TMPFILE=$(mktemp /tmp/colors.XX)

function exit_pgm() {
   rm -rf $TMPFILE >& /dev/null
   exit_restore_screen
}

function show_colors() {
   str="\\x1b[38;5;m"
   local j=0
   for i in {0..254} ; do
      printf "\x1b[38;5;${i}mcolor${i} " >> $TMPFILE
      j=$(($j + 1 ))
      [[ $j -eq 5 ]] && j=0 && printf "\n" >> $TMPFILE
   done
}

#################################
## Main
###
trap exit_pgm INT

# Create an alternate screen
enter_alt_screen

show_colors $TMPFILE
cat $TMPFILE | column -t

read_escape_cmd && exit_pgm
