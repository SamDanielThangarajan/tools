#!/usr/bin/env bash

#script to install all vim plugins and setup vim config file
#Next step is to remove all these things and make use of vundle

SCRIPT_DIR=$(dirname $0)
SCRIPT_PATH=$(cd -P "$SCRIPT_DIR" && pwd -P)
CURRENT_DIR=$(pwd)
TMPFILE=$(mktemp /tmp/vim.setup.XXXXXX)
TMP_REMINDER_FILE=$(mktemp /tmp/vim.setup.XXXXXX)

VIM_DIR="${HOME}/.vim"
VIM_RC="${HOME}/.vimrc"
VIM_BUNDLE_DIR="${VIM_DIR}/bundle/"
PROJECT_VIM_CONFIG="${HOME}/project_vim_config"

VERBOSE_REDIRECT=/dev/null
BACKUP=1

function log_detail {
    echo "vim setup> $@" 1>&${VERBOSE_REDIRECT}
}

# Function to check exit status
# $1 exit status
# $2 message to be printed
function act_on_exit_status {
    local exit_status=$1
    local msg=$2
    if [ ${exit_status} -ne 0 ];then
        echo "${msg} failed, Error code ${exit_status}, Exiting..."
	[[ -f ${TMPFILE} ]] && cat ${TMPFILE} && rm -rf ${TMPFILE}
	log_detail "Error. exiting..."
        exit $exit_status
    fi
}

function process_options {
    OPTS=`getopt -o vnr: --long verbose,no-backup,reminder-file: -- "$@"`
    act_on_exit_status $? "getopt"
    eval set -- "$OPTS"

    while true ; do
        case "$1" in
        -v|--verbose ) VERBOSE_REDIRECT=1 && shift ;;
        -n|--no-backup ) BACKUP=0; shift ;;
	      -r|--reminder-file ) REMINDER_REDIRECT=$2; shift 2;;
        -- ) shift; break;;
        * ) break ;;
        esac
    done
}


#########################################
# Main program
#########################################


process_options $@

log_detail "started."

#1. Take Backup of .vim directory
if [[ ${BACKUP} -eq 1 ]];then
   for item in ${VIM_DIR} ${VIM_RC}
   do
      log_detail "Backing up $item"
      [[ -e $item ]] && cp -rf $item $item.backup
   done
fi

log_detail "Removing ${VIM_DIR} ${VIM_RC}"
rm -rf ${VIM_DIR} ${VIM_RC} 2>/dev/null

log_detail "Creating directory infra"
mkdir -p ${VIM_DIR}/{backup,plugin,bundle,ftplugin,nerdtree_plugin} ${PROJECT_VIM_CONFIG}

log_detail "Installing vundle."
git clone https://github.com/VundleVim/Vundle.vim.git ${VIM_BUNDLE_DIR}/Vundle.vim >& ${TMPFILE}
act_on_exit_status $? "Install Vundle"

log_detail "Writing ${VIM_RC}"
cat <<EOI > ${VIM_RC}
let tools_path = '${SCRIPT_PATH}/vimrc'
if filereadable(tools_path)
   exe 'source' tools_path
endif
EOI

log_detail "Installing Vim plugins.."
vim +PluginInstall +qall
cp ${SCRIPT_PATH}/cscope_maps.vim ${VIM_DIR}/plugin

log_detail "Importing all helptags"
for plugin in ${VIM_BUNDLE_DIR}/*/; do
   vim -u NONE -c "helptags ${plugin}/doc" -c q
done
vim -u NONE -c "helptags ${VIM_DIR}/doc" -c q

log_detail "Installing filetype plugins...."
for file in $(ls $SCRIPT_PATH/ftplugin/*.vim)
do
   ln -s ${file} ${VIM_DIR}/ftplugin/
done

log_detail "Installing NerdTree mappings"
ln -s ${SCRIPT_PATH}/nerdtree_plugin/mappings.vim ${VIM_DIR}/nerdtree_plugin/mappings.vim


log_detail "Installing Go binaries."
# PErhaps this doesn't work now?
vim +GoInstallBinaries +qall

log_detail "Writing reminders."
cat <<EOF > ${TMP_REMINDER_FILE}

VIM reminders:
python[3] -m pip install flake8
Install Mac vim
pip3 install yamllint (https://github.com/adrienverge/yamllint)
EOF

[[ -n ${REMINDER_REDIRECT} ]] && cat ${TMP_REMINDER_FILE} >> ${REMINDER_REDIRECT} || cat ${TMP_REMINDER_FILE}

rm -rf ${TMPFILE} ${TMP_REMINDER_FILE}

#END Get back to same location
cd ${CURRENT_DIR}

log_detail "completed."
