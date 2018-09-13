#!/usr/bin/env bash

[[ -z ${TOOLS} ]] \
   && >&2 echo "ENV{TOOLS} not defined" \
   && exit 1

# Extract the operation
operation=$1 && shift

function prunedockercontainers() {
   /usr/local/bin/docker container prune -f
   sleep 15
}

function prunesetupbackups() {
   ls -t -1 ${HOME}/setup_tools.sh_* | tail -n +2 | xargs rm
   ls -t -1 ${HOME}/tools_alias_* | tail -n +2 | xargs rm
   ls -t -1 ${HOME}/.gitconfig_* | tail -n +2 | xargs rm
   ls -dt -1 ${HOME}/.vim_* | tail -n +2 | xargs rm -rf
   sleep 15
}

function timesheetslave() {
   open -na safari $(cat ${HOME}/timesheet.url)
}

function tmuxunreadmailcount() {
   count=$(${TOOLS}/mactools/launch_agents/scripts/outlook.unread-mail-count)
   if [[ $count -eq 0 ]]
   then
      echo "#[fg=colour154,bg=colour238,nobold,nounderscore,noitalics]#[fg=colour238,bg=colour154] No mails" > $HOME/.unread
   else
      echo "#[fg=colour196,bg=colour238,nobold,nounderscore,noitalics]#[fg=colour15,bg=colour196] Mails: $count" > $HOME/.unread
   fi
   sleep 15
}


function list-service-info() {
   cat <<EOS
prunedockercontainers:300
prunesetupbackups:3600
tmuxunreadmailcount:30
EOS
}

function list-timedservice-info() {
#service:minute:hour:day:weekday:Month   
   cat <<EOTS
timesheetslave:21:16:-:5:-
EOTS
}

$operation $@
exit 0

