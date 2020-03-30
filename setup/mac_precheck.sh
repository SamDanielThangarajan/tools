#!/usr/bin/env bash

g_time=$(date +%T)
g_script_name=$0
g_cur_dir=$(dirname -- "${BASH_SOURCE[0]}")
g_script_path=$(cd -P "$g_cur_dir" && pwd -P)
g_tools_path=$(cd -P "$g_script_path"/.. && pwd -P)

echo "Mac pre check..."
. ${g_tools_path}/common.sh


for i in curl perl
do
  is_installed $i
  act_on_exit_status $? "$i has to be installed manually yet!"
done


[[ $(is_installed brew) -ne 0 ]] && install_brew


for i in wget tmux git cmake cscope ctags gnu-getopt htop watch python3
do
  [[ $(is_installed $i) -ne 0 ]] && brewinstall $i
done


for i in powerline-status flake8 pytest
do
  [[ $(is_pip_listed $i) -ne 0 ]] && pipinstall $i
done
 

[[ -f /Applications/MacVim.app/Contents/MacOS/Vim ]] \
  && mvim_installed=1 || mvim_installed=0

if [[ ${mvim_installed} -eq 0 ]]
then
  echo "Downloading mac vim..."
  latest_mvim_hook=https://github.com/macvim-dev/macvim/releases/latest
  latest=$(curl -s -o /dev/null -w %{redirect_url} ${latest_mvim_hook} | awk -F'/' '{print $NF}')
  act_on_exit_status $? "Unable to get latest mvim"
  wget --no-check-certificate https://github.com/macvim-dev/macvim/releases/download/${latest}/MacVim.dmg
  act_on_exit_status $? "Unable to download latest mvim"
  echo "Install the downloaded MacVim.dmg and restart the setup"
  exit 0
fi


exit 0
