#!/bin/bash

prefix='k8s'
hosts=("master" "node1" "node2" "node3")

for name in ${hosts[@]}; do
  virsh shutdown ${prefix}-${name}

  #todo: ensure master stopped completely first
done 
