#!/bin/bash

#Usage: ./script <operation> server:port <project> refs/changes/55/244055/2 new_branch_name

if [[ $# -lt 4 ]]
then
   cat <<EOF

   Usage: $0 operation server:port project reference [local_branch]

   operation : checkout|cherry-pick

   local_branch is used when checkout option is used.
EOF
exit 1
fi

OPERATION=$1
SERVER_AND_PORT=$2
PROJECT=$3
REF=$4

BRANCH=""
[[ $# -eq 5 ]] && BRANCH=$5

git fetch ssh://${USER}@${SERVER_AND_PORT}/${PROJECT} ${REF} >& /dev/null && git ${OPERATION} FETCH_HEAD >& /dev/null

if [[ ${OPERATION}="checkout" && $# -eq 5 ]]
then
   git checkout -b ${BRANCH} >& /dev/null
   cat <<EOF
   Upstream branch not set. use git branch to set it

   Example:
   git branch --set-upstream-to=origin/master


> Switched to ${BRANCH} branch
EOF
fi
