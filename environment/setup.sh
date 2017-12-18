#!/usr/bin/env bash

g_time=$(date +%T)
g_script_name=$0
g_cur_dir=$(dirname -- "${BASH_SOURCE[0]}")
g_script_path=$(cd -P "$g_cur_dir" && pwd -P)
g_tools_path=$(cd -P "$g_script_path"/.. && pwd -P)
g_master_setup_file=/home/${USER}/setup_tools.sh
g_nodes_config=/home/${USER}/nodes.cfg
g_debug=0

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

#Arg exit status
function print_usage_and_exit {
   echo "Usage : ${g_script_name} -r <repo-base> -n <name> -e <email> [-dh]"
   echo "      repo-base : parent directory for all projects"
   echo "      name : name to be used in git config"
   echo "      email : email to be used in git config"
   exit $1
}

function process_options {
    OPTS=`getopt -o r:n:e:dh --long repo-base:,debug,name:,email:,help -n 'setup.sh' -- "$@"`
    act_on_exit_status $? "getopt"
    eval set -- "$OPTS"

    while true ; do
        case "$1" in
        -r|--repo-base ) g_repo_base=$2; shift 2;;
        -d|--debug ) g_debug=1; shift ;;
        -n|--name ) g_name=$2; shift 2;;
        -e|--email ) g_email=$2; shift 2;;
        -h|--help ) print_usage_and_exit 0;;
        -- ) shift; break;;
        * ) break ;;
        esac
    done

    debug "Repo base : ${g_repo_base}"
    if [[ -z ${g_repo_base} ]] || [[ -z ${g_name} ]] || [[ -z ${g_email} ]];
    then
       print_usage_and_exit 1
    fi

    return 0
}

#Arg 1 - debug message
function debug {
   if [[ ${g_debug} -eq 1 ]];then
      echo "$1"
   fi
}

function backup_files {

   debug "Backing up files and folders"
   backup_list[0]=${g_master_setup_file}
   backup_list[1]=/home/${USER}/.vimrc
   backup_list[2]=/home/${USER}/.gitconfig
   backup_list[3]=/home/${USER}/.tmux.conf
   backup_list[3]=/home/${USER}/.vim
   backup_list[4]=/home/${USER}/tools_alias

   local i=0
   for file in ${backup_list[@]};
   do
      debug "$file ... backingup"
      if [[ -d ${file} ]]; then
         cp -r ${file} ${file}_${g_time}
         g_backedup_list[${i}]=${file}_${g_time}
      fi

      if [[ -f ${file} ]]; then
         cp ${file} ${file}_${g_time}
         g_backedup_list[${i}]=${file}_${g_time}
      fi
      i=$(expr $i + 1)
   done
   debug "Backing up files and folders ...done"

}


function write_master_setup_file {

debug "Writing master setup file"

cat<<EOI >${g_master_setup_file} 

#!/usr/bin/env bash

#Export variables
export REPO_BASE=${g_repo_base}
export TOOLS=${g_tools_path}

# Some vi exports to marry vim with tmux
# Two giant robots colide :)
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Show a * when branch has changed content
export GIT_PS1_SHOWDIRTYSTATE=true

# Setup nodes.cfg file
export NODES_CONFIG=${g_nodes_config}

# Write tool alias
${g_tools_path}/environment/write_tools_alias.sh

# Sourcing alias
source ${g_tools_path}/environment/alias
[[ -f /home/${USER}/tools_alias ]] && source /home/${USER}/tools_alias

echo ""

export PATH=${g_tools_path}:\${PATH}

# Display any reminders
if [ -f ~/reminders ]; then
   cat ~/reminders
fi

EOI

chmod +x ${g_master_setup_file}
debug "Writing master setup file ...done"
}

function deploy_git_config
{
   local gitconfig=/home/${USER}/.gitconfig
   cp ${g_tools_path}/config/gitconfig ${gitconfig}
   sed -i "s/@name/name = ${g_name}/g" ${gitconfig}
   sed -i "s/@email/email = ${g_email}/g" ${gitconfig}
   debug "git config setup ...done"

   git --version >& /dev/null

   if [[ $? -ne 0 ]];then
      echo "*** git is not installed in the system!"
   fi

}

function deploy_tmux_config
{
   cp ${g_tools_path}/config/tmux.conf /home/${USER}/.tmux.conf
   debug "tmux config setup ...done"

   tmux -V >& /dev/null

   if [[ $? -ne 0 ]];then
      echo "*** tmux is not installed in the system!"
   fi

}

function touch_needed_config_files {
if [[ ! -f ${g_nodes_config} ]];
then
cat <<ENC >${g_nodes_config}
#config format
#alias_name user_name ipAddress
ENC
echo "Fillin node details in ${g_nodes_config}.."
fi
}

###########################################
## Main
###

process_options $@

backup_files 
debug ""

write_master_setup_file
debug ""

echo "Setting up vim configuration, please wait"
${g_script_path}/vim_setup.sh -n
debug ""

deploy_git_config
debug ""

deploy_tmux_config
debug ""

touch_needed_config_files
debug ""

# Write custom alias
export REPO_BASE=${g_repo_base}
${g_script_path}/write_tools_alias.sh

echo "Created following back-up files..."
for file in ${g_backedup_list[@]};
do
   debug "${file}"
done
echo ""

echo "*** custom alias created in /home/${USER}/tools_alias"
echo "*** ${g_master_setup_file} has to be sourced for every shell"

