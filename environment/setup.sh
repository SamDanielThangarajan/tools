export REPO_BASE="/repo" #Give a repository name

BASEPATH=$(dirname -- "${BASH_SOURCE[0]}")
SCRIPTPATH=$(cd -P "$BASEPATH" && pwd -P)


if [ -f ~/tools/environment/sam_gitcomplete ]; then
    source ~/tools/environment/sam_gitcomplete
    echo "Setting up git complete setup ...done"
fi


GIT_PS1_SHOWDIRTYSTATE=true

export NODES_CONFIG=~/tools/environment/nodes.cfg

source ~/tools/environment/sam_alias

echo ""
echo ""

if [ -f ~/reminders ]; then
    cat ~/reminders
fi
