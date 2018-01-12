#!/usr/bin/env bash

# NOT COMPLETE

src_dirs=""
dest_dir=""
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

function usage() {
   cat <<EOF

   usage $0 -s <source directories> -d <dest directory>

   source directories : command seperated list
EOF
}

function exit_if_not_dir() {
   local src_dir=$1
   [[ ! -d ${src_dir} ]] \
      && echo "${src_dir} : No such directory" \
      && exit 1
}

function handle_src() {
   local src_dir=$1
   cd ${src_dir}
   for f in $(find . -name \* -print)
   do
      f_name=$(basename $f)

      echo $f_name | egrep '^[0-9]{8}_.*'
      [[ $? -ne 0 ]] && continue

      year=$(echo ${f_name: 0:4})
      month=$(echo ${f_name: 4:2})
      month_exp=${month_converter[${month}]}

      dir=${dest_dir}/${year}/${month_exp}

      mkdir -p ${dir}

      mv -n ${f} ${dir}/${f_name}

      [[ $? -ne 0 ]] \
         && echo "${f} existing, not overwriting" \
         && continue
   done

}

################################################
## Arguments
###
while getopts ":s:d:" opt; do
   case $opt in
      s)
         src_dirs=$OPTARG
         ;;
      d)
         dest_dir=$OPTARG
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

[[ ${src_dirs} = "" ]] \
   && usage \
   && exit 1

for src_dir in ${src_dirs}
do
   exit_if_not_dir ${src_dir}
done

[[ ${dest_dir} = "" ]] \
   && usage \
   && exit 1

exit_if_not_dir ${dest_dir}

################################################
## Main
###

working_dir=$(pwd)

IFS=","
for src_dir in ${src_dirs}
do
   handle_src ${src_dir}
done

cd ${working_dir}

echo "SRC DIRS : $src_dirs"
echo "DEST DIR : $dest_dir"
