#!/usr/bin/env bash

plainB_redF="#[fg=colour196,bg=colour238]"
redB_whiteF="#[fg=colour15,bg=colour196]"
blueB_whiteF="#[fg=colour15,bg=colour39]"
plainB_blueF="#[fg=colour39,bg=colour238]"
reset_color="#[fg=colour238,bg=colour238]"
plainB_yelF="#[fg=colour3,bg=colour238]"
yelB_blaF="#[fg=colour0,bg=colour3]"
plainB_greF="#[fg=colour118,bg=colour238]"
greB_blaF="#[fg=colour0,bg=colour118]"

rc="$HOME/.tmuxstatusrc"

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
   open -na safari $(cat ${rc}/timesheet.url)
}
function tmuxunreadmailcount() {
   count=$(${TOOLS}/mactools/launch_agents/scripts/outlook.unread-mail-count)
   if [[ $count -eq 0 ]]
   then
      echo "" > $rc/unread
   else
      #echo "${plainB_redF}${redB_whiteF} Mails: $count${reset_color}" > $rc/unread
      echo "${plainB_blueF}${blueB_whiteF} Mails: $count${reset_color}" > $rc/unread
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
#timesheetslave:21:16:-:5:-
   cat <<EOTS
EOTS
}

$operation $@
exit 0

