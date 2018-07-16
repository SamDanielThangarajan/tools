#!/usr/bin/env bash

#. $TOOLS/common.sh
#enter_alt_screen
#trap exit_restore_screen INT

project_name=${PROJECT_NAME}
clone_name=${CLONE_NAME}
types_to_search_count=0
files_to_search_count=0
search_flags=""

function process_key_value_argument() {
   key=$(echo $1 | cut -d '=' -f 1)
   value=$(echo $1 | cut -d '=' -f 2)
   if [[ $key = "type" ]]
   then
      types_to_search[$types_to_search_count]=$value
      types_to_search_count=$(($types_to_search_count+1))
   elif [[ $key = "clone-name" ]]
   then
      clone_name=$value
   elif [[ $key = "project-name" ]]
   then
      project_name=$value
   fi
}

function process_arguments() {
   for arg in $@
   do
      if [[ $arg =~ ^[^=]+=[^=]+$ ]]
      then
         process_key_value_argument $arg
      elif [[ $arg = "--exact-match" ]]
      then
         search_flags="$search_flags -w -o"
      elif [[ $arg = "--greedy" ]]
      then
         greedy_find=1
      elif [[ $arg =~ ^-.+$ ]]
      then
         search_flags="$search_flags $arg"
      else
         files_to_search[$files_to_search_count]=$arg
         files_to_search_count=$(($files_to_search_count+1))
      fi
   done

   [[ -z $project_name ]] && echo "Neither ENV{PROJECT_NAME} nor argument project-name=? is provided" && exit 1
   [[ -z $clone_name ]] && echo "Neither ENV{CLONE_NAME} nor argument clone-name=? is provided" && exit 1

}

function find_files() {
   tag_file=${HOME}/project_tags/${project_name}/${clone_name}/tags
   [[ ! -f ${tag_file} ]] && echo "No tag file present. Generate tags first!" && exit 1

   for i in "${files_to_search[@]}"
   do
      search_exp=$search_exp"$i|"
   done
   search_exp=${search_exp%?}

   for i in "${types_to_search[@]}"
   do
      t_search_exp=$t_search_exp"$i|"
   done
   t_search_exp=${t_search_exp%?}

   filtered_files=($(egrep -i $search_exp ${tag_file} | awk '{print $2}' | sort | uniq))

   for line in "${filtered_files[@]}"
   do
      file=$(echo $line | awk -F'/' '{print $NF}')
      file_type=$(echo $file | awk -F'.' '{print $NF}')
      file_name=$(echo $file | awk -F'.' '{print $1}')
 
      # Incase greedy find, search entire path
      [[ -n $greedy_find ]] && file_name=$line

      if [[ $types_to_search_count -ne 0 ]]
      then
         echo $file_type | egrep -wo $t_search_exp >&/dev/null
         [[ $? -ne 0 ]] && continue
      fi

      echo $file_name | egrep $search_flags $search_exp >&/dev/null
      [[ $? -eq 0 ]] && echo $line

   done

}


#################################
## MAIN
###

process_arguments $@
find_files

#read_escape_cmd && exit_restore_screen
