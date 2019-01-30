#!/usr/bin/env bash

. $TOOLS/common.sh

function exit_pgm() {
   exit_restore_screen
}
trap exit_pgm INT

function showrepos() {
   # Create an alternate screen
   enter_alt_screen

   for repo in `ls $REPO_BASE`
   do
      echo "$repo"
      for clone in `ls $REPO_BASE/$repo`
      do
         echo " -- $clone"
      done
      echo ""
   done
   read_escape_cmd && exit_pgm
}

function createrepo() {
   [[ $# -lt 2 ]] \
      && >&2 echo "Usage: createrepo <repo-name> <url> [clone_name]" \
      && exit 1
   [[ $# -eq 3 ]] && clone=$3 || clone="clone"
   repo=$1 && url=$2 && repo_dir=$REPO_BASE/$1
   mkdir -p $repo_dir
   echo "$url" > $repo_dir/.repo.cfg
   cd $repo_dir
   git clone $url $clone
   cd -
}

function createclone() {
   [[ $# -ne 2 ]] \
      && >&2 echo "Usage: createrepo <repo-name> <clone_name>" \
      && exit 1
   repo=$1 && clone=$2 && repo_dir=$REPO_BASE/$1

   [[ ! -d $repo_dir ]] \
      && >&2 echo "$repo not created yet!" \
      && exit 1

   [[ ! -f $repo_dir/.repo.cfg ]] \
      && >&2 echo "$repo not created using create-repo!" \
      && exit 1

   [[ -d $repo_dir/$clone ]] \
      && >&2 echo "$clone already exists" \
      && exit 1

   url=$(cat $repo_dir/.repo.cfg)
   cd $repo_dir
   git clone $url $clone
   cd -
}

[[ -z ${REPO_BASE} ]] \
   && >&2 echo "ENV{REPO_BASE} not defined" \
   && exit 1

# Extract the operation
operation=$1 && shift

$operation $@
exit 0
