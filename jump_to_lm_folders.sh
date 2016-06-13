#!/bin/bash

JUMPED=0
exit_status=1
function error()
{
    echo "$1"
    return 1 2> /dev/null || exit 1
}

function jump_exit()
{
    cd $1
    JUMPED=1
    echo "Directory : $1" 
    return 0 2> /dev/null || exit 0
}

#Some jump Dirs
IN_LM_SOURCE=$CLONE_ROOT/src/lmServer/src/$1
IN_LM_SRC_TOOLS=$CLONE_ROOT/src/tools/$1
IN_LM_JCAT=$CLONE_ROOT/src/tools/Jcat/$1


#Process
[[ -d ${IN_LM_SOURCE} ]] && jump_exit ${IN_LM_SOURCE}
[[ -d ${IN_LM_SRC_TOOLS} ]] && jump_exit ${IN_LM_SRC_TOOLS}
[[ -d ${IN_LM_JCAT} ]] && jump_exit ${IN_LM_JCAT}

[[ ${JUMPED} -eq 0 ]] && echo "Unable to perform jump, No such Directory!" || exit_status=0

return ${exit_status} || exit ${exit_status}




