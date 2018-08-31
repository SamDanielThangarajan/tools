
_remoteop() 
{

   local cur prev opts
   COMPREPLY=()
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   opts=""
   if [[ ${COMP_CWORD} -eq 1 ]]
   then
      opts="login exec scp rscp rsync rrsync"
   else
      opts=$(cat ~/nodes.cfg | egrep -v '^#|^$' | awk '{print $1}' | tr "\n" " ")
   fi

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _remoteop remote
