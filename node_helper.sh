#!/bin/bash

g_user=''
g_ip=''
g_leftOverParams=''
g_remotePath=''
g_sourceAliases="false"
g_listNodes="false"
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Function to check exit status
# $1 exit status
# $2 message to be printed
function act_on_exit_status {
    local exit_status=$1
    local msg=$2
    if [ ${exit_status} -ne 0 ];then
        echo "${msg} failed, Error code ${exit_status}, Exiting..."
        exit $exit_status
    fi
}

function process_options {
    OPTS=`getopt -o a:n:p:sl --long action:,node:,--remote-path:,--source-aliases,--list -n 'node_helper.sh' -- "$@"`
    act_on_exit_status $? "getopt"
    eval set -- "$OPTS"

    while true ; do
        case "$1" in
        -a|--action ) g_action=$2; shift 2;;
        -n|--node ) g_node=$2; shift 2;;
        -p|--remote-path ) g_remotePath=$2; shift 2;; 
        -s|--source-aliases ) g_sourceAliases="true"; shift ;;
        -l|--list ) g_listNodes="true"; shift ;;
        -- ) shift; break;;
        * ) break ;;
        esac
    done

    if [ ${g_sourceAliases} = "true" ] || [ ${g_listNodes} = "true" ];
    then
        return 0
    fi

    if [ -z ${g_action} ] || [ -z ${g_node} ];
    then
        act_on_exit_status 1 "Mandatory Arguments Missing"
    fi

    g_leftOverParams=${@}
}

function check_node_config {
    if [ -z ${NODES_CONFIG} ] || [ ! -e ${NODES_CONFIG} ];
    then
        act_on_exit_status 1 "Environment NODE_CONFIG is missing (or) invalid"
    fi

    line=$(grep --word-regexp ${g_node} ${NODES_CONFIG})
    act_on_exit_status $? "No matching nodes in ${NODES_CONFIG}"

    g_user=$(echo $line | cut -d ' ' -f 2)
    act_on_exit_status $? "Unable to retreive username from ${NODES_CONFIG} for $g_node"

    g_ip=$(echo $line | cut -d ' ' -f 3)
    act_on_exit_status $? "Unable to retreive ipaddress from ${NODES_CONFIG} for $g_node"

}

function execute_ssh {
    ssh ${g_user}@${g_ip}
}

function execute_import {
    scp ${g_user}@${g_ip}:${g_remotePath} ${g_leftOverParams}
}

function execute_export {
    scp ${g_leftOverParams} ${g_user}@${g_ip}:${g_remotePath}
}

function alias_execute_ssh {
    ${SCRIPT_PATH}/node_helper.sh -a login -n $1
}

function alias_execute_scp {
    local action=$1;shift
    local node=$1;shift
    local remote_path=$1;shift

    if [ ${action} = "import" ];then
        ${SCRIPT_PATH}/node_helper.sh -a import -n $node -p $remote_path $@
    elif [ ${action} = "export" ];then
        ${SCRIPT_PATH}/node_helper.sh -a export -n $node -p $remote_path $@
     fi
}

function main {

    process_options $@

    if [ ${g_sourceAliases} = "true" ];
    then
        echo "Sourcing Node related aliases"
        alias login='alias_execute_ssh'
        alias exp='alias_execute_scp export'
        alias imp='alias_execute_scp import'
        alias sn="${SCRIPT_PATH}/node_helper.sh -l | less"
    elif [ ${g_listNodes} = "true" ];
    then
        echo "Available Nodes"
        cat $NODES_CONFIG |egrep -v '^#' | awk -F' ' '{print $1 "\t\t" $3}'
    else
        check_node_config

        case "${g_action}" in
            login ) execute_ssh
                ;;
            export ) execute_export
                ;;
            import ) execute_import
                ;;
             * ) echo "No action";;
        esac
    
    fi
}

main $@
