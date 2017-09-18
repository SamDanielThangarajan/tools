#!/usr/bin/env bash


OPTS=`getopt -o p:c: --long project:,clone: -n 'setclone.sh' -- "$@"`
if [ $? != 0 ]
then
    exit 1
fi
eval set -- "$OPTS"

while true ; do
    case "$1" in
    -p|--project ) PROJECT=$2; shift 2;;
    -c|--clone ) CLONE=$2; shift 2;;
        -- ) shift; break;;
    * ) break ;;
    esac
done

clone=${REPO_BASE}/${PROJECT}/${CLONE}
custom_setup_script=${REPO_BASE}/${PROJECT}/setup.sh

if [ -d ${clone} ];
then
	export CLONE_ROOT=${clone}
	cd $CLONE_ROOT	
	export CLONE_NAME=${CLONE}
    export PROJECT_NAME=${PROJECT}
    PROMPT_COMMAND="source ${REPO_BASE}/tools/clone/updatebranch.sh"
    export PS1='\[\e[0;31m\]\h\[\e[0;32m\]:\[\e[0;31m\]\t\[\e[0;32m\]:\[\e[0;31m\]$GIT_BRANCH\[\e[0;32m\]\$\[\e[0m\]'
	export CCACHE_DIR=/tmp/.ccache.${USER}
	export CCACHE_TEMPDIR=/tmp/.ccache.tmp.${USER}
	export CCACHE_LOGFILE=/tmp/.ccache.${USER}/logfile
    [[ -f ${custom_setup_script} ]] && source ${custom_setup_script}
	echo "Clone[${CLONE}] set for project[${PROJECT}]"
    echo "Directory : ${clone}" 
else
	echo "Clone[${CLONE}] not found under project[${PROJECT}]"
fi

#Proper way for prompt
    #if [ -f ~/git-prompt.sh ]; then
    #    ~/git-prompt.sh
    #fi
    #GIT_PS1_SHOWDIRTYSTATE=true
    #export PS1='\[\e[0;31m\]\h\[\e[0;32m\]:\[\e[0;31m\]\t\[\e[0;32m\]:\[\e[0;31m\]$(__git_ps1)\[\e[0;32m\]\$\[\e[0m\]'
