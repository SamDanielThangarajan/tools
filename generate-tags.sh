#!/usr/bin/env bash

project_name=""
clone_name=""
clone_root=""
cscope_out_tmp=/tmp/generate_tags.tmp

function exit_pgm() {
   rm -rf ${cscope_out_tmp} 2> /dev/null
}

trap exit_pgm INT

function process_key_value_argument() {
   key=$(echo $1 | cut -d '=' -f 1)
   value=$(echo $1 | cut -d '=' -f 2)
   if [[ $key = "project-name" ]]
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
      else
         clone_name=$arg
      fi
   done

   [[ -z $project_name ]] && echo "Argument project-name=? not provided" && exit 1
   [[ -z $clone_name ]] && echo "Argument clone-name=? not provided" && exit 1

   clone_root=${REPO_BASE}/${project_name}/${clone_name}

}


function check_clone() {
   [[ ! -d ${clone_root} ]] \
      && echo "${clone_root} : No such clone present" \
      && exit 1  
}

function generate_tags() {

   tag_dir=${HOME}/project_tags/${project_name}/${clone_name}
   tag_file=${tag_dir}/tags
   cscope_file=${tag_dir}/cscope.out

   mkdir -p ${tag_dir}

   echo "$(hostname) : generating ctags for clone ${project_name}/${clone_name}"
   ctags \
      -R \
      --sort=1 \
      --c++-kinds=+p \
      --fields=+iaS \
      --extra=+q \
      --exclude=boost* \
      --exclude=gmock* \
      --exclude=poco* \
      --exclude=thrift-* \
      -f ${tag_file} \
      ${clone_root}

   echo "$(hostname) : generating cscope db for clone ${project_name}/${clone_name}"

   #Collect the files
   cat ${tag_file} | awk '{print $2}' | grep "^${REPO_BASE}" | uniq > ${cscope_out_tmp}
   cscope -b -f ${cscope_file} -i ${cscope_out_tmp}

}

#################################
## MAIN
###

process_arguments $@
check_clone
generate_tags
exit_pgm

