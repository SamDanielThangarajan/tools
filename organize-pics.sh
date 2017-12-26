#!/usr/bin/env bash

alias_file="$TOOLS/environment/alias"
number_of_dirs_created=0
number_of_files_moved=0
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

# Step1: create year directory
for dir in $(yr-mn-in-photo-dir)
do
   month=$(echo ${dir: 4:2})
   year=$(echo ${dir: 0:4})
   dir=${year}/${month_converter[${month}]}
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
   mv ${file} ${year}/${month_exp}
   number_of_files_moved=$(($number_of_files_moved+1))
done

# Step 3: Print stats
echo "${number_of_dirs_created} directories created"
echo "${number_of_files_moved} files moved"
