[[ -z "$REPO_BASE" ]] && echo "Need to set variable REPO_BASE " && exit 1

BASEPATH=$(dirname -- "${BASH_SOURCE[0]}")
SCRIPTPATH=$(cd -P "$BASEPATH" && pwd -P)


if [ -f ~/tools/environment/sam_gitcomplete ]; then
    source ~/tools/environment/sam_gitcomplete
fi


GIT_PS1_SHOWDIRTYSTATE=true

export NODES_CONFIG=~/tools/environment/nodes.cfg

source ~/tools/environment/sam_alias

# Some VI exports to marry VIM with TMUX
# Two giant robots colide :)
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo ""

if [ -f ~/reminders ]; then
    cat ~/reminders
fi
