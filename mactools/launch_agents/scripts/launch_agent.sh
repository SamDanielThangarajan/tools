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
plainB_greenF="#[fg=colour46,bg=colour238]"
greenB_yellowF="#[fg=colour220,bg=colour46]"

rc="$HOME/.tmuxstatusrc"
push_notification_dir="${HOME}/.pushnotification"

[[ -z ${TOOLS} ]] \
   && >&2 echo "ENV{TOOLS} not defined" \
   && exit 1

# Extract the operation
operation=$1 && shift
config_file=$HOME/.launchagents/$operation

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
      echo "${plainB_redF}${redB_whiteF} Mails: $count${reset_color}" > $rc/unread
   fi
   sleep 15
}

function gmailinboxunreadcount() {
   export HTTPS_PROXY=$(cat ${HOME}/.tmuxstatusrc/https_proxy)
   count=$(${TOOLS}/google_scripts/gmail/get_label.py -t ${HOME}/.gmail/.creds/token.json -l INBOX -f threadsUnread 2> /tmp/error.txt)
   if [[ $? -ne 0 ]]
   then
      echo "${plainB_redF}${redB_whiteF} gmail: -${reset_color}" > $rc/gmail.unread
   else
      if [[ $count -eq 0 ]]
      then
   	echo "" > $rc/gmail.unread
      else
         echo "${plainB_redF}${redB_whiteF} gmail: $count${reset_color}" > $rc/gmail.unread
      fi
   fi
   sleep 15
}

function pushnotification() {
   for f in `ls ${push_notification_dir}/*`
   do
      title=$(awk -F':' '{print $1}' $f)
      desc=$(awk -F':' '{print $2}' $f)
      $(${TOOLS}/mactools/launch_agents/scripts/push-notification "${title}" "${desc}")
      rm -rf $f
   done
}

function monitorvisastatus() {

  tmp_op=$rc/visastat.tmp
  op=$rc/visastat
  control_no=$(cat $rc/visastat.inp)
  url="https://www.migrationsverket.se/Kontakta-oss/Min-sida-och-Kontrollera-din-ansokan/Kontrollera-din-ansokan-utan-inloggning.html"
  rm -rf ${tmp_op} 2>/dev/null

  # If previous curl failed, don't query again.. Manual fix is needed
  # To prevent getting locked out in proxy.
  if [[ -f $op ]]
  then
    grep -q visa-monitor-failed:FIX_PROXY $op
    [[ $? -eq 0 ]] && sleep 15 && return
  fi

  HTTPS_PROXY=$(cat $rc/https_proxy) /usr/bin/curl -s -d "typenr=2&q=${control_no}" -X POST ${url} -o $tmp_op

  [[ $? -ne 0 ]] \
	  && echo "${plainB_redF}${redB_whiteF} visa-monitor-failed:FIX_PROXY ${reset_color}" > $op \
	  && sleep 15 && return

  grep ">I väntan på beslut<" ${tmp_op} | grep -q 'class="active"'
  [[ $? -eq 0 ]] \
	  && echo "${plainB_yelF}${yelB_blaF} visa-pending ${reset_color}" > $op \
	  && sleep 15 && return

  grep ">Beslut fattat<" ${tmp_op} | grep -q 'class="active"'
  [[ $? -eq 0 ]] \
	  && echo "${plainB_greF}${greB_blaF} visa-decided ${reset_color}" > $op \
	  && sleep 15 && return

  echo "${plainB_redF}${redB_whiteF} visa-monitor-failed ${reset_color}" > $op
  sleep 15
}



# Function that lists all the service agents to be launched.
function list-service-info() {
   cat <<EOS
prunedockercontainers:300
prunesetupbackups:3600
tmuxunreadmailcount:30
gmailinboxunreadcount:60
monitorvisastatus:1800
EOS
}

# Funtion for all directory service
function list-dir-service-info() {
   cat <<EOS
pushnotification:${push_notification_dir}
EOS
}


function list-timedservice-info() {
#service:minute:hour:day:weekday:Month   
#timesheetslave:21:16:-:5:-
   cat <<EOTS
EOTS
}

# If switch is off, then exit the script
grep -sq "switch: off" $config_file
[[ $? -eq 0 ]] && sleep 15 && exit 0

$operation $@
exit 0

