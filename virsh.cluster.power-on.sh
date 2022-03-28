#!/bin/bash

source ./virsh.cluster.info

for name in ${hosts[@]}; do
  virsh start ${prefix}-${name}
done 
