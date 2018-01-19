#!/usr/bin/env bash

namespace=$1 && shift
operation=$1 && shift

function get-pods(){
   kubectl get pods -n $namespace
}


function login-to-pod(){
   pod=$1
   echo "Logging to pod : $pod"
   echo ""
   echo ""
   kubectl exec -it $pod -n $namespace bash
}

function exec-in-pod(){
   pod=$i
   echo "Executing $@ in $pod"
   echo ""
   echo ""
   kubectl exec $pod -n $namespace $@
}

#Main
$operation $@

