# tools

This repository contains the tools and environment specific to me. If you some piece
useful, feel free to pick it up.

## Installation
1. clone this repository
2. ./environment/setup.sh -r <repo_base> -n <name>  -e <email>

## What does this setup do?
1. Sets up vim configuration and install all the plugins.
2. Deploys the tmux and gitconfig custom files.
3. Writes a setup_tools.sh in user's home which has to be sourced everytime a new
shell is spawned.
4. Writes a tools_alias in user's home which will be sourced by the setup_tools
.sh


### What is repo base?
Repo base is the root directory for all the projects you work with.

Example:
/repo/my_projects -> repo_base
/repo/my_projects/proj1 -> proj1
/repo/my_projects/proj1/clone1 -> proj1's clone1
/repo/my_projects/proj1/clone2 -> proj2's clone1
/repo/my_projects/proj2 -> proj2
/repo/my_projects/proj2/clone -> proj2's clone

The tools_alias will create indeividual set_clone.sh alias for these projects.
Example:
To set clone1 for proj1 : proj1 clone1
To set clone2 for proj1 : proj1 clone2

Indexing is done by ctags and cscope. To index a clone of a project,
generateTags.py can be used. There are individual alias written for it in
tools_alias.

Example:
To index clone1 of proj2
index-proj2 clone1

These cscope and ctags output will be placed in /home/${USER}/project_tags/<project_name>/<clone-name>

The vi whill use it.
