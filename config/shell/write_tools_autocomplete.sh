#!/usr/bin/env bash

[[ -z ${REPO_BASE} ]] && echo "REPO_BASE is not set. exiting" && exit 1
[[ -z ${TOOLS} ]] && echo "TOOLS is not set. exiting" && exit 1

g_time=$(date +%T)
g_repo_base=${REPO_BASE}
g_autocomplete_file=${HOME}/tools_autocomplete

function custom_ac_writer
{
   echo "$1" >> ${g_autocomplete_file}
}

################################
## Main
###

echo "Writing tools auto complete ${g_time}"

rm -rf ${g_autocomplete_file}

custom_ac_writer "##########################################"
custom_ac_writer "## Auto complete (${g_time})"
custom_ac_writer "###"
custom_ac_writer ""

for file in $(ls ${g_repo_base})
do
   custom_ac_writer "complete -F _setclone ${file}"
   custom_ac_writer "complete -F _setclone index-${file}"
done
custom_ac_writer ""

custom_ac_writer "# Auto complete for setclones"
custom_ac_writer "source ${TOOLS}/auto-complete-scripts/dockerssh-autocomplete.sh"
custom_ac_writer ""
custom_ac_writer ""
