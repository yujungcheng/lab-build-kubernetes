#!/bin/bash

source ./virsh.cluster.info

for name in ${hosts[@]}; do
  echo "restoring ${prefix}-${name}"
  virsh snapshot-revert ${prefix}-${name} --snapshotname init
done 