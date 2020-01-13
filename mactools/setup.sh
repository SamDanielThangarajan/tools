#!/usr/bin/env bash

[[ -z ${TOOLS} ]] \
   && >&2 echo "ENV{TOOLS} not defined" \
   && exit 1

# Setup valid only for mac hosts (TODO: Func missing for Linux)
[[ $(uname -s) != "Darwin" ]] \
   && exit 0

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Setting up Mac tools... "

####################
## Setting up Launch Agents
###

ns=com.sam.mactools
template_file=${ns}.service.plist.tmpl
dir_template_file=${ns}.dirservice.plist.tmpl
timed_template_file=${ns}.timedservice.plist.tmpl
config_dir=$HOME/.launchagents

function create_service_config() {
    service=$1
    [[ ! -f $config_dir/$service ]] && echo "switch: on" >> $config_dir/$service
}

function load_service_agent() {
   service=$1 && shift
   interval=$1

   cat $TOOLS/mactools/launch_agents/${template_file} \
      | sed "s#@TOOLS@#${TOOLS}#g" \
      | sed "s#@SERVICE@#${service}#g" \
      | sed "s#@INTERVAL@#${interval}#g" \
      > ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   create_service_config $service

   launchctl unload -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist 2>/dev/null
   launchctl load -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   [[ $? -ne 0 ]] \
      && echo "mactools> WARNING! Loading of $service failed!"
}

function load_dir_service_agent() {
   service=$1 && shift
   dir_to_mon=$1

   rm -rf ${dir_to_mon} 2> /dev/null && mkdir -p ${dir_to_mon}

   cat $TOOLS/mactools/launch_agents/${dir_template_file} \
      | sed "s#@TOOLS@#${TOOLS}#g" \
      | sed "s#@SERVICE@#${service}#g" \
      | sed "s#@DIR_MONITOR@#${dir_to_mon}#g" \
      > ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   create_service_config $service

   launchctl unload -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist 2>/dev/null
   launchctl load -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   [[ $? -ne 0 ]] \
      && echo "mactools> WARNING! Loading of $service failed!"
}

function load_timedservice_agent() {
   service=$1 && shift
   minute=$1 && shift
   hour=$1 && shift
   day=$1 && shift
   weekday=$1 && shift
   month=$1 && shift

   df=${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   cat $TOOLS/mactools/launch_agents/${timed_template_file} \
      | sed "s#@TOOLS@#${TOOLS}#g" \
      | sed "s#@SERVICE@#${service}#g" \
      > ${df}

   create_service_config $service

   [[ $minute != "-" ]] && \
      sed -i '' "s#.*@MINUTE@.*#<key>Minute</Key><integer>$minute</integer>#g" ${df}
   [[ $hour != "-" ]] && \
      sed -i '' "s#.*@HOUR@.*#<key>Hour</Key><integer>$hour</integer>#g" ${df}
   [[ $day != "-" ]] && \
      sed -i '' "s#.*@DAY@.*#<key>Day</Key><integer>$day</integer>#g" ${df}
   [[ $weekday != "-" ]] && \
      sed -i '' "s#.*@WEEKDAY@.*#<key>Weekday</Key><integer>$weekday</integer>#g" ${df}
   [[ $month != "-" ]] && \
      sed -i '' "s#.*@MONTH@.*#<key>Month</Key><integer>$month</integer>#g" ${df}

   launchctl unload -w ${df} 2>/dev/null
   launchctl load -w ${df}

   [[ $? -ne 0 ]] \
      && echo "mactools> WARNING! Loading of $service failed!"
}

mkdir -p $config_dir/

#Load OnDemand LaunmchAgents
for service in $(${script_dir}/launch_agents/scripts/launch_agent.sh list-service-info)
do
   s=$(echo $service | cut -d ':' -f 1)
   i=$(echo $service | cut -d ':' -f 2)
   load_service_agent $s $i
done


#Load DirMonitor LaunmchAgents
for service in $(${script_dir}/launch_agents/scripts/launch_agent.sh list-dir-service-info)
do
   s=$(echo $service | cut -d ':' -f 1)
   d=$(echo $service | cut -d ':' -f 2)
   load_dir_service_agent $s $d
done


#Load TimerBased LaunmchAgents
for service in $(${script_dir}/launch_agents/scripts/launch_agent.sh list-timedservice-info)
do
   echo $service
   s=$(echo $service | cut -d ':' -f 1)
   mi=$(echo $service | cut -d ':' -f 2)
   hr=$(echo $service | cut -d ':' -f 3)
   da=$(echo $service | cut -d ':' -f 4)
   wd=$(echo $service | cut -d ':' -f 5)
   mo=$(echo $service | cut -d ':' -f 6)
   #load_timedservice_agent $s $mi $hr $da $wd $mo
done
