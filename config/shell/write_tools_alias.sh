#!/usr/bin/env bash

[[ -z ${REPO_BASE} ]] && echo "REPO_BASE is not set. exiting" && exit 1

g_time=$(date +%T)
g_repo_base=${REPO_BASE}

function custom_alias_writer
{
   echo -e "$1" >> ${HOME}/tools_alias
}

################################
## Main
###

echo "Writing custom alias on ${g_time}"

rm -rf ${HOME}/tools_alias

custom_alias_writer "##########################################
## Custom alias (${g_time})
###"


custom_alias_writer "# Setup git clones"
for file in $(ls ${g_repo_base})
do
   custom_alias_writer "alias ${file}=\"source \${TOOLS}/setclone.sh --project ${file} --clone\""
   custom_alias_writer "alias index-${file}=\"\${TOOLS}/generate-tags.sh project-name=${file}\""

   project_cfg=${g_repo_base}/${file}/gerrit.project.cfg
   if [ -f $project_cfg ]
   then
      p_name=$(grep "gerrit.name" ${project_cfg} | cut -d '=' -f 2)
      port=$(grep "gerrit.port" ${project_cfg} | cut -d '=' -f 2)
      server=$(grep "gerrit.server" ${project_cfg} | cut -d '=' -f 2)
      author=$(grep "gerrit.author" ${project_cfg} | cut -d '=' -f 2)
      custom_alias_writer "alias $file-qry-open=\"gerrit-query -S $server -P $port --project $p_name -s open\""
      custom_alias_writer "alias $file-qry-merged=\"gerrit-query -S $server -P $port --project $p_name -s merged\""
      custom_alias_writer "alias $file-qry-open-mine=\"gerrit-query -S $server -P $port --project $p_name -s open -a \\\"$author\\\"\""
      custom_alias_writer "alias $file-qry-merged-mine=\"gerrit-query -S $server -P $port --project $p_name -s merged -a \\\"$author\\\"\""

      custom_alias_writer "alias $file-checkout=\"gerrit-checkout $server:$port $p_name\""
      custom_alias_writer "alias $file-cherrypick=\"gerrit-cherrypick $server:$port $p_name\""
   fi

done

custom_alias_writer "

# Node related alias
"

while read alias node user passd
do
   [[ $alias =~ ^# ]] && continue
   printf \
    "alias login-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp login $node $user $passd\"\n" \
    "alias rsync-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp rsync $node $user $passd\"\n" \
    "alias rrsync-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp rrsync $node $user $passd\"\n" \
    "alias scp-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp scp $node $user $passd\"\n" \
    "alias rscp-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp rscp $node $user $passd\"\n" \
    "alias exec-${alias}=\"${TOOLS}/remote_scripts/remote_op.exp exec $node $user $passd\"\n" \
    >> ${HOME}/tools_alias
done<$HOME/nodes.cfg
