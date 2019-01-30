
_createclone() 
{

   local cur prev opts
   COMPREPLY=()
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   opts=""
   if [[ ${COMP_CWORD} -eq 1 ]]
   then
      opts=$(ls $REPO_BASE)
   fi

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _createclone create-clone
