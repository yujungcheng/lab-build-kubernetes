#!/bin/bash

source ./virsh.cluster.info

for name in ${hosts[@]}; do
  virsh shutdown ${prefix}-${name}

  #todo: ensure master stopped completely first
done 
