#!/usr/bin/env bash

if [ -d ${CLONE_ROOT} ]; then
    #branch=`cat ${CLONE_ROOT}/.git/HEAD | cut -d '/' -f 3`
    branch=`cat ${CLONE_ROOT}/.git/HEAD | sed 's#ref: refs/heads/##g' | sed 's#feature/##g'` 
    export GIT_BRANCH=${branch}
else
    export GIT_BRANCH="Nil"
fi
