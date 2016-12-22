#!/usr/bin/env bash

#script to install all vim plugins and setup vim config file
#Next step is to remove all these things and make use of vundle

g_project_vim_config="/home/${USER}/project_vim_config"
g_script_dir=$(dirname $0)
g_current_dir=$(pwd)
g_vim_dir="/home/${USER}/.vim/"
g_vim_bundle_dir="/home/${USER}/.vim/bundle/"
g_redirect=/dev/null
g_nobackup=0


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
    OPTS=`getopt -o vn --long verbose,no-backup -n 'vim_setup.sh' -- "$@"`
    act_on_exit_status $? "getopt"
    eval set -- "$OPTS"

    while true ; do
        case "$1" in
        -v|--verbose ) g_redirect=1; shift ;;
        -n|--no-backup ) g_nobackup=1; shift ;;
        -- ) shift; break;;
        * ) break ;;
        esac
    done
}



# Function to perform a git clone
# $1 clone path E.g: 
# $2 message to be printed
function git_clone {
   local clone=$1
   local target_directory=$2
   git clone ${clone} ${target_directory} >& ${g_redirect}
   [[ $? -ne 0 ]] && echo "Failed to clone : ${clone}" && return 1
   return 0
}

# Function to install a plugin from zip file
# $1 plugin name
# $2 path to the zip location 
function zip_install {
   local plugin_name=$1
   local plugin_path=$2
   mkdir /tmp/${plugin_name}_tmp
   cd /tmp/${plugin_name}_tmp
   wget ${plugin_path} -O ${plugin_name}.zip >& ${g_redirect}
   [[ $? -ne 0 ]] && echo "Failed to download : ${plugin_name}:${plugin_path}" && return 1
   unzip -u ${plugin_name}.zip -d ~/.vim/ >& ${g_redirect}
   [[ $? -ne 0 ]] && echo "Failed to unzip : ${plugin_name}:${plugin_path}" && return 1
   cd -
   rm -rf /tmp/${plugin_name}_tmp
   return 0
}

# Function to install pathogen
function install_pathogen {
   mkdir -p ~/.vim/autoload ~/.vim/bundle && \
   curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim >& ${g_redirect}
}

process_options $@

#1. Take Backup of .vim directory
if [[ ${g_nobackup} -eq 0 ]];then
   [[ -d ~/.vim ]] && cp -r ~/.vim ~/vim.backup
fi
rm -rf ~/.vim
mkdir ~/.vim

#2. Create project specific vim locations
[[ -d ${g_project_vim_config} ]] || mkdir ${g_project_vim_config}

#3 . Install vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
act_on_exit_status $? "Install Vundle"

#4. Take Backup of .vimrc
if [[ ${g_nobackup} -eq 0 ]];then
   [[ -f ~/.vimrc ]] && cp ~/.vimrc ~/vimrc.backup
fi

#5. Deploy vimrc
cp ${g_script_dir}/../config/vimrc ~/.vimrc
act_on_exit_status $? "Deploy vimrc"

#6. Install Plugins
vim +PluginInstall +qall

#7. Import all the helptags
for plugin in ${g_vim_bundle_dir}/*/; do
   vim -u NONE -c "helptags ${plugin}/doc" -c q
done
vim -u NONE -c "helptags ${g_vim_dir}/doc" -c q

#8. Get back to same location
cd ${g_current_dir}
