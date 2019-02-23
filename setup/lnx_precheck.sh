#!/usr/bin/env bash

g_time=$(date +%T)
g_script_name=$0
g_cur_dir=$(dirname -- "${BASH_SOURCE[0]}")
g_script_path=$(cd -P "$g_cur_dir" && pwd -P)
g_tools_path=$(cd -P "$g_script_path"/.. && pwd -P)

echo "Linux precheck called..."
exit 0
