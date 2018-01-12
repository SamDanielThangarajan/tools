#!/usr/bin/env bash

#NOT COMPLETE

alias_file="$TOOLS/environment/alias"
number_of_dirs_created=0
number_of_files_moved=0
dest_dir=""
field=1
declare -A month_converter=( \
   ["01"]="jan" \
   ["02"]="feb" \
   ["03"]="mar" \
   ["04"]="apr" \
   ["05"]="may" \
   ["06"]="jun" \
   ["07"]="jul" \
   ["08"]="aug" \
   ["09"]="sep" \
   ["10"]="oct" \
   ["11"]="nov" \
   ["12"]="dec")
cmd_to_list_files_alone="ls -l | grep ^- | awk -F' ' '{print \$9}'"

# Source our aliases
[[ ! -f ${alias_file} ]] \
   && echo "${alias_file} not found" \
   && exit 1
shopt -s expand_aliases
source $TOOLS/environment/alias

################################################
## Arguments
###
while getopts ":d:p:f:" opt; do
   case $opt in
      d)
         dest_dir=$OPTARG
         ;;
      f)
      field=$OPTARG
         ;;
      \?)
         echo "Invalid option: -$OPTARG" >&2
         exit 1
         ;;
      :)
         echo "Option -$OPTARG requires an argument." >&2
         exit 1
   esac
done

[[ ${dest_dir} = "" ]] \
   && usage \
   && exit 1

################################################
## Main
###

cmd="ls -1 | cut -d '_' -f $field | sort | uniq | egrep  '^[0-9]{8}' | sed 's/.\{2\}$//' | sort | uniq"

# Step1: create year directory
for dir in $(${cmd})
do
   month=$(echo ${dir: 4:2})
   year=$(echo ${dir: 0:4})
   dir=${year}/${month_converter[${month}]}

   [[ ${dest_dir} != "" ]] \
      && dir=${dest_dir}/${dir}

   [[ ! -d ${dir}  ]] \
      && mkdir -p ${dir} \
      && number_of_dirs_created=$(($number_of_dirs_created+1))
done


# Step 2: Move files to corresponding dirs
for file in $(ls -l | grep ^- | awk -F' ' '{print $9}')
do

   # pattern matches?
   echo $file | egrep '^[0-9]{8}_.*'
   [[ $? -ne 0 ]] && continue

   year=$(echo ${file: 0:4})
   month=$(echo ${file: 4:2})
   month_exp=${month_converter[${month}]}

   dir=${year}/${month_exp}
   [[ ${dest_dir} != "" ]] \
      && dir=${dest_dir}/${dir}

   mv -n ${file} ${dir}/${file}

   [[ $? -ne 0 ]] \
      && echo "${file} existing, not overwriting" \
      && continue

   number_of_files_moved=$(($number_of_files_moved+1))
done

# Step 3: Print stats
echo "${number_of_dirs_created} directories created"
echo "${number_of_files_moved} files moved"
