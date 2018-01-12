#!/usr/bin/env bash

# This command expects KUBECONFIG to be set properly

function usage() {
   cat <<EOF

Deletes all resources which belong to the namespace.

usage:
$0 <namespace>

Notes: Extend this file with deleting selected resources.
EOF
}

[[ $# -ne 1 ]] \
   && usage \
   && exit 1

namespace=$1

cmd="kubectl get all -o=name --no-headers=true -n $namespace"

for i in $($cmd)
do
   echo ""
   echo "Deleting $i"
   kubectl delete $i -n $namespace
   [[ $? -ne 0 ]] \
      && echo "Deleting $i failed, exiting"
done

