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
   pod=$1
   shift
   echo "Executing $@ in $pod"
   echo ""
   echo ""
   kubectl exec $pod -n $namespace $@
}

function exec-all(){
   get_pods="kubectl get pods -n pm -o=custom-columns=name:.metadata.name --no-headers"
   for pod in $(${get_pods})
   do
      echo "Output from $pod"
      exec-in-pod $pod $@
      echo ""
      echo ""
   done
}


#Main
$operation $@

