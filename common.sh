#!/usr/bin/env bash

function enter_alt_screen() {
   tput smcup
}

function exit_restore_screen() {
   tput rmcup
   [[ $# -ne 0 ]] && exit $@
   exit 0
}

function read_escape_cmd() {
   while true
   do
      read -n 1 var
      [[ $var = 'q' ]] && return 0
   done
}
