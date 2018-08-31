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

function load_agent() {
   service=$1 && shift
   interval=$1

   cat $TOOLS/mactools/launch_agents/${template_file} \
      | sed "s#@TOOLS@#${TOOLS}#g" \
      | sed "s#@SERVICE@#${service}#g" \
      | sed "s#@INTERVAL@#${interval}#g" \
      > ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   launchctl unload -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist 2>/dev/null
   launchctl load -w ${HOME}/Library/LaunchAgents/${ns}.${service}.plist

   [[ $? -ne 0 ]] \
      && echo "mactools> WARNING! Loading of $service failed!"
}

for service in $(${script_dir}/launch_agents/scripts/launch_agent.sh list-service-info)
do
   s=$(echo $service | cut -d ':' -f 1)
   i=$(echo $service | cut -d ':' -f 2)
   load_agent $s $i
done
