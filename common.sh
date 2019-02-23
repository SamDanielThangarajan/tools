#!/usr/bin/env bash

[[ -z ${CERT} ]] && ca_cert="" || ca_cert="--cert ${CERT}"

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

# Function to check exit status
# $1 exit status
# $2 message to be printed
function act_on_exit_status {
    local exit_status=$1
    local msg=$2
    if [ ${exit_status} -ne 0 ];then
        echo "${msg} failed, Error code ${exit_status}, Exiting..."
        exit $exit_status
    fi
}

function is_installed() {
  which $1 >& /dev/null
  return $?
}

function is_pip_listed() {
  pip3 list | grep $1 >& /dev/null
  return $?
}

function install_brew() {
  /usr/bin/ruby \
    -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  act_on_exit_status $? "brew install failed"

}

function brewinstall() {
  echo "brew> installing $1"
  brew install $1 >& /dev/null
  act_on_exit_status $? "brew install $1 failed"
}

function pipinstall() {
  echo "pip3> installing $1"
  pip3 install $ca_cert $1 
  act_on_exit_status $? "pip3 install $1 failed, check CERT variable?"
}
