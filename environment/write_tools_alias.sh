#!/usr/bin/env bash

[[ -z ${REPO_BASE} ]] && echo "REPO_BASE is not set. exiting" && exit 1

g_time=$(date +%T)
g_repo_base=${REPO_BASE}

function custom_alias_writer
{
   echo "$1" >> /home/${USER}/tools_alias
}

################################
## Main
###

echo "Writing custom alias on ${g_time}"

rm -rf /home/${USER}/tools_alias

custom_alias_writer "##########################################"
custom_alias_writer "## Custom alias (${g_time})"
custom_alias_writer "###"
custom_alias_writer ""


custom_alias_writer "# Setup git clones"
for file in $(ls ${g_repo_base})
do
   custom_alias_writer "alias ${file}=\"source \${TOOLS}/setclone.sh --project ${file} --clone\""
done
custom_alias_writer ""

custom_alias_writer "# Index projects"
for file in $(ls ${g_repo_base})
do
   custom_alias_writer "alias index-${file}=\"python \${TOOLS}/generatetags.py --project ${file} --clone\""
done
custom_alias_writer ""

custom_alias_writer "# Gerrit commands"
for file in $(ls ${g_repo_base})
do
   project_cfg=${g_repo_base}/${file}/project.cfg
   [[ ! -f ${project_cfg} ]] && continue

   echo "Writing gerrit alias for project $file"
   p_name=$(grep "gerrit.name" ${project_cfg} | cut -d '=' -f 2)
   port=$(grep "gerrit.port" ${project_cfg} | cut -d '=' -f 2)
   server=$(grep "gerrit.server" ${project_cfg} | cut -d '=' -f 2)
   author=$(grep "gerrit.author" ${project_cfg} | cut -d '=' -f 2)
   custom_alias_writer "alias gq-$file-open=\"gerrit-query -S $server -P $port --project $p_name -s open\""
   custom_alias_writer "alias gq-$file-merged=\"gerrit-query -S $server -P $port --project $p_name -s merged\""
   custom_alias_writer "alias gq-$file-open-mine=\"gerrit-query -S $server -P $port --project $p_name -s open -a \\\"$author\\\"\""
   custom_alias_writer "alias gq-$file-merged-mine=\"gerrit-query -S $server -P $port --project $p_name -s merged -a \\\"$author\\\"\""
done
