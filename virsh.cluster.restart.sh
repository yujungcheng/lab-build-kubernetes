#!/bin/bash

prefix='k8s'
hosts=("master" "node1" "node2" "node3")

for name in ${hosts[@]}; do
  virsh reboot ${prefix}-${name}
done 
