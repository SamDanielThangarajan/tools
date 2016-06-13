#!/bin/bash

if [ -d ${CLONE_ROOT} ]; then
    branch=`cat ${CLONE_ROOT}/.git/HEAD | cut -d '/' -f 3`
    export GIT_BRANCH=${branch}
else
    export GIT_BRANCH="Nil"
fi
