
_dockerssh() 
{

   local cur prev opts
   COMPREPLY=()
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   opts=""
   if [[ ${COMP_CWORD} -eq 1 ]]
   then
      opts="name id"
   fi

   if [[ ${COMP_CWORD} -eq 2 ]]
   then
      [[ ${prev} = "name" ]] && opts=$(docker ps -f status=running --format={{.Names}} | tr "\n" " ")
      [[ ${prev} = "id" ]] && opts=$(docker ps -f status=running --format={{.ID}} | tr "\n" " ")
   fi

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _dockerssh docker-ssh
