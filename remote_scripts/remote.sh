#!/usr/bin/env bash

#$1 is the action
#$2 is the alias

[[ $# -lt 2 ]] && echo "Usage: $0 <cmd> <nodealias>" && exit 1

cmd=$1 && shift
alias=$1 && shift

node_cfg=$(egrep "^$alias " ~/nodes.cfg)

$TOOLS/remote_scripts/remote_op.exp \
   $cmd \
   $(echo $node_cfg | awk '{print $2 " " $3 " " $4}') \
   "$@"


