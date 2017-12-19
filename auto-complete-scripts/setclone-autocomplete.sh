
# This auto complete has to be meant for
# the aliases using the setclone.sh
#
# Example:
# For alias proj_name=source setclone.sh --project proj_name --clone 
#
# complete -F _setclone proj_name

_setclone() 
{

   local cur prev opts
   COMPREPLY=()
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   proj_name=${prev}

   opts=$(for i in $(ls -d ${REPO_BASE}/${proj_name}/*/); do echo ${i%%/} | xargs basename ; done)

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
