#!/bin/bash

#Usage: ./script server:port <project> refs/changes/55/244055/2 new_branch_name

[[ $# -ne 4 ]] && echo "Usage: ./script <server_port> <project> <reg> <branch_name>" && exit 1

SERVER_AND_PORT=$1
PROJECT=$2
REF=$3
BRANCH=$4

git fetch ssh://${USER}@${SERVER_AND_PORT}/${PROJECT} ${REF} && git checkout FETCH_HEAD
git checkout -b ${BRANCH}
#git branch --set-upstream-to  origin/master

echo ""
echo ""
echo "> Switched to ${BRANCH}"
echo ""
echo ""

