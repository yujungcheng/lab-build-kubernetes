#!/bin/bash

source ./virsh.cluster.info

# ensure required variable are defined.
set -u
#: "${hosts}"
: "${hosts:?variable 'hosts' is not set or empty.}"

for name in ${hosts[@]}; do
  virsh domifaddr ${prefix}-${name}
done
