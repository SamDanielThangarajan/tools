#!/usr/bin/env bash

[[ -z ${TOOLS} ]] \
   && >&2 echo "ENV{TOOLS} not defined" \
   && exit 1

# Extract the operation
operation=$1 && shift

function prunedockercontainers() {
   /usr/local/bin/docker container prune -f
}

function prunesetupbackups() {
   ls -t -1 ${HOME}/setup_tools.sh_* | tail -n +2 | xargs rm
   ls -t -1 ${HOME}/tools_alias_* | tail -n +2 | xargs rm
   ls -t -1 ${HOME}/.gitconfig_* | tail -n +2 | xargs rm
   ls -dt -1 ${HOME}/.vim_* | tail -n +2 | xargs rm -rf
   
}
function list-service-info() {
   cat <<EOS
prunedockercontainers:300
prunesetupbackups:3600
EOS
}

$operation $@
sleep 10

