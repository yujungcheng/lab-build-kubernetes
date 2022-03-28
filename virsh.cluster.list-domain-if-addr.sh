#!/bin/bash

source ./virsh.cluster.info

for name in ${hosts[@]}; do
  virsh domifaddr ${prefix}-${name}
done
