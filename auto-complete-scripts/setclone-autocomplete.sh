
# This auto complete has to be meant for
# the aliases using the setclone.sh
#
# Example:
# For alias source setclone.sh --project proj_name --clone 
#
# complete -F _setclone <proj_name>
# complete -F _setclone index-<proj_name>

_setclone() 
{

   local cur prev opts
   COMPREPLY=()

   # Only one level of completion is needed.
   [[ ${#COMP_WORDS[@]} -gt 2 ]] && return 

   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   # Extract project name from the command
   if [[ $prev == "index-"* ]]
   then
      proj_name=$(echo $prev | cut -d '-' -f 2)
   else
      proj_name=${prev}
   fi

   opts=$(for i in $(ls -d ${REPO_BASE}/${proj_name}/*/); do echo ${i%%/} | xargs basename ; done)

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
