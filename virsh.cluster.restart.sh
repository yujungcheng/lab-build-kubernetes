#!/bin/bash

source ./virsh.cluster.info

for name in ${hosts[@]}; do
  virsh reboot ${prefix}-${name}
done 
