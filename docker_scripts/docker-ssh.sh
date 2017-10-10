#!/usr/bin/env bash

filename=$(basename $0)

function usage()
{
   cat <<EOF

Usage:
  $filename <id|name|-h> value [user]

EOF
}

# Check usage
if [[ $# -gt 0 ]]
then
   [[ $1 = "-h" ]] && usage && exit 0
   [[ $1 = "--help" ]] && usage && exit 0
   [[ $1 = "help" ]] && usage && exit 0
fi

[[ $# -lt 2 ]] && usage && exit 1

filter=$1
value=$2
_cont=`docker container ls --quiet --filter "$filter=$value\$"`

[[ ! -n $_cont ]] && echo "No container found" && exit 1

_ip=$(docker inspect $_cont \
      | grep \"IPAddress\" \
      | sed 's/\s*//g' \
      | sed 's/[,"]//g' \
      | sort | uniq \
      | cut -d ":" -f 2)

echo "Logging in to $_ip"

ssh_cmd_prefix=""
[[ $# -eq 3 ]] && ssh_cmd_prefix="$3@"

#Performing ssh
ssh $ssh_cmd_prefix$_ip