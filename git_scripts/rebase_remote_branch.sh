#!/usr/bin/env bash

usage () {
   cat <<EOF
usage:
   rebase_remote_branch <index_of_commits>

   Example: to rebase feature/feature1~5
   rebase_remote_branch 5
EOF
}

[[ $# -ne 1 ]] && usage && return

INDEX=$1
BRANCH=$( git branch | egrep '^\*' | awk '{print $2}' )

REBASE_CMD="git rebase -i origin/${BRANCH}~${INDEX} ${BRANCH}"
FORCE_PUSH_CMD="git push origin +${BRANCH}"
echo -n "Performing ${REBASE_CMD}, confirm [y/n]"
read -n 1 answer
[[ ${answer} = "y" ]] || echo "Bye..." && echo ""

$( ${REBASE_CMD} )

echo -n "Performing ${FORCE_PUSH_CMD}, confirm [y/n]"
read -n 1 answer
[[ ${answer} = "y" ]] || echo "Bye..." && echo ""
$( ${FORCE_PUSH_CMD} )
