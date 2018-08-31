# Scripts for remote node access

These scripts help in having alias names for remote nodes and accessing them using these names + taking leverage on the <TAB> to autocomplete the commands.


Automation include  
- login to remote node
- rsync to and from a remote node
- scp to and from a remote location
- executing a command on remote node

## 1. Setup

### 1.1 Create a nodes.cfg file in your home dir
Example:
```
cat ~/nodes.cfg
#Aliasname node_address username password
node1 node1.sample.com user1 password1
node2 node2.sample.com user2 password2
node2 1.1.1.1 user3 password3
```

### 1.2 Place these scripts in your preferred paths:
- remote_op.exp
- remote.sh
- show_nodes.sh
- ../auto-complete-scripts/remote-autocomplete.sh

```
Note: remote.sh has a variable $TOOLS, replace it to appropriate location
```

### 1.3 Creating Aliases

There are 2 ways to use these automations
- Approach 1: Create separate aliases for each node
- Approach 2: Create one alias and autocomplete the action(login, exec, scp, rsync, rrsync) and node alias using TAB

#### 1.3.1 Approach 1
Paste the following script in your bash_profile
```
while read line
do
   [[ $line =~ ^# ]] || && continue
   token_count=$(echo $line | wc -w)
   [[ $token_count -ne 4 ]] && continue

   alias=$(echo $line | awk '{print $1}')
   node=$(echo $line | awk '{print $2}')
   user=$(echo $line | awk '{print $3}')
   passwd=$(echo $line | awk '{print $4}')
   alias login-${alias}="<PATH>/remote_scripts/remote_op.exp login $node $user $passwd"
   alias rsync-${alias}="<PATH>/remote_scripts/remote_op.exp rsync $node $user $passwd"
   alias rrsync-${alias}="<PATH>/remote_scripts/remote_op.exp rrsync $node $user $passwd"
   alias scp-${alias}="<PATH>/remote_scripts/remote_op.exp scp $node $user $passwd"
   alias rscp-${alias}="<PATH>/remote_scripts/remote_op.exp rscp $node $user $passwd"
   alias exec-${alias}="<PATH>/remote_scripts/remote_op.exp exec $node $user $passwd"
done<$HOME/nodes.cfg
```
```
Note: replace <PATH> to a appropriate location.
```

#### 1.3.2 Approach 2
Paste the following in your bash_profile
```
alias remote="<PATH>/remote_scripts/remote.sh"
source remote-autocomplete.sh
```

### 1.4 Other aliases
```
alias sn=<PATH>/remote_scripts/show_nodes.sh
```
At any point hit sn<enter> to open an alternate terminal to list the nodes in a
table format. Hit ```q``` to exit the alt terminal

# 2. Usage

## 2.1 Approach 1
```
Hitting TAB should list the complete the command with node alias.

login-TAB          # login to the node using it alias
exec-TAB "CMD"   # Executes the command on the target node
rsync-TAB src dest # Rsync the src on your local computer to remote node
rrsync-TAB src dest # rRsync the src on your remote computer to local node
scp-TAB src dest   # Scp the src on your local to remote  
rscp-TAB src dest  # Scp the src from remote node to dest on your local
```

## 2.2 Approach 2
```
remote TAB TAB

#First (sets of) TAB autocompletes the action
exec
login
scp
rscp
rsync
rrsync

# Next (sets of) TAB autocompletes the node Aliases

Example:
remote exec node1 "ls"
remote login node2
remote rsync node1 ./src /tmp/dest
```

# TODO
1. Support for automatically appending ssh pub of the local account to the remote authorized_keys if the same account is used on both the ends.
