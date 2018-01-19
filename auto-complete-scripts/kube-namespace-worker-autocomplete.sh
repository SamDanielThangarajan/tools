
_kuber() 
{

   local cur prev opts
   COMPREPLY=()
   prev="${COMP_WORDS[COMP_CWORD-1]}"
   cur="${COMP_WORDS[COMP_CWORD]}"

   opts=""

   # Prepare namespace
   if [[ ${COMP_CWORD} -eq 1 ]]
   then
      opts=$(kubectl get ns -o=name --no-headers=true | cut -d / -f 2 | tr "\n" " ") 
   fi

   # Prepare subcommands
   if [[ ${COMP_CWORD} -eq 2 ]]
   then
      opts="get-pods login-to-pod exec-in-pod"
   fi

   # Process Subcommands
   if [[ ${COMP_WORDS[2]} = "get-pods" ]]
   then
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return
   fi
   
   if [[ ${COMP_WORDS[2]} = "login-to-pod" ]] ||
      [[ ${COMP_WORDS[2]} = "exec-in-pod" ]]
   then

      [[ ${COMP_CWORD} -ne 3 ]] && return

      namespace=${COMP_WORDS[1]}
      opts=$( kubectl get pods -o=name --no-headers=true -n $namespace | cut -d / -f 2)
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return
   fi

   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _kuber kuber

