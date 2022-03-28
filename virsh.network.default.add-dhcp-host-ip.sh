#!/bin/bash

source ./virsh.cluster.info

for vm in "${hosts[@]}"; do
  name="${prefix}-${vm}"
  virsh net-update default add ip-dhcp-host "<host mac='${k8s_node_mac[${name}]}' name='${name}' ip='${k8s_node_ip[${name}]}'/>" --live --config
done