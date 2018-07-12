#!/usr/bin/env bash

g_time=$(date +%T)
g_script_name=$0
g_cur_dir=$(dirname -- "${BASH_SOURCE[0]}")
g_script_path=$(cd -P "$g_cur_dir" && pwd -P)
g_tools_path=$(cd -P "$g_script_path"/.. && pwd -P)
g_master_setup_file=${HOME}/setup_tools.sh
g_nodes_config=${HOME}/nodes.cfg
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
   cat<<EOF

   Usage : ${g_script_name} repo-base=<dir> name=<name> email=<email> [debug]
EOF
   exit $1
}

function process_options {
    for arg in $@
    do
       if [[ $arg =~ ^[^=]+=[^=]+$ ]]
       then
          key=$(echo $arg | cut -d '=' -f 1)
          value=$(echo $arg | cut -d '=' -f 2)
          [[ $key = "repo-base" ]] && g_repo_base=$value
          [[ $key = "name" ]] && g_name=$value
          [[ $key = "email" ]] && g_email=$value
       else
          [[ $arg = "debug" ]] && g_debug=1
          [[ $arg = "help" ]] && print_usage_and_exit 0
       fi
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
   backup_list[1]=${HOME}/.vimrc
   backup_list[2]=${HOME}/.gitconfig
   backup_list[3]=${HOME}/.tmux.conf
   backup_list[3]=${HOME}/.vim
   backup_list[4]=${HOME}/tools_alias

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

# Write tool alias (for every new shell)
${g_tools_path}/environment/write_tools_alias.sh

# write auto complete (for every new shell)
${g_tools_path}/environment/write_tools_autocomplete.sh

# Sourcing alias
source ${g_tools_path}/environment/alias
[[ -f ${HOME}/tools_alias ]] \
   && source ${HOME}/tools_alias

# Sourcing static auto complete
[[ -f ${g_tools_path}/auto-complete-scripts/setup.sh ]] \
   && source ${g_tools_path}/auto-complete-scripts/setup.sh

# Sourcing auto complete
[[ -f ${HOME}/tools_autocomplete ]] \
   && source ${HOME}/tools_autocomplete

echo ""

export PATH=${g_tools_path}:\${PATH}

# Display any reminders
if [ -f ~/reminders ]; then
   cat ~/reminders
fi

# Setting up colors
export LSCOLORS="ExfxcxdxBxegecabagacad"

EOI

chmod +x ${g_master_setup_file}
debug "Writing master setup file ...done"
}

function deploy_git_config
{
   local gitconfig=${HOME}/.gitconfig
   cp ${g_tools_path}/config/gitconfig ${gitconfig}
   sed -i '' "s/@name/name = ${g_name}/g" ${gitconfig}
   sed -i '' "s/@email/email = ${g_email}/g" ${gitconfig}
   debug "git config setup ...done"

   git --version >& /dev/null

   if [[ $? -ne 0 ]];then
      echo "*** git is not installed in the system!"
   fi

}

function deploy_tmux_config
{
   cp ${g_tools_path}/config/tmux.conf ${HOME}/.tmux.conf
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

# Write auto complete
export TOOLS=${g_tools_path}
${g_script_path}/write_tools_autocomplete.sh

echo "Created following back-up files..."
for file in ${g_backedup_list[@]};
do
   debug "${file}"
done
echo ""

echo "*** custom alias created in ${HOME}/tools_alias"
echo "*** ${g_master_setup_file} has to be sourced for every shell"

