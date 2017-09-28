#!/usr/bin/env bash


if [[ -f ${CLONE_ROOT}/.git/HEAD ]]
then
   branch=`cat ${CLONE_ROOT}/.git/HEAD | sed 's#ref: refs/heads/##g' | sed 's#feature/##g'`
   export GIT_BRANCH=${branch}
else
   export GIT_BRANCH="Nil"
fi
