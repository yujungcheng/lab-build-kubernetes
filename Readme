## Build Kubernetes Home Lab
Ansible playbooks and scripts to build kubernetes vm cluster in my home lab.
The kubernetes cluster includss 1 master node and 3 worker nodes.

## Node Spec.
- VM: k8s-master, hostname=master, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-node1, hostname=worker-1, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-node2, hostname=worker-2, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-node3, hostname=worker-3, vCPU=2, Ram=4G, Disk=16G

OS: Ubuntu 20.04
Username: ubuntu
Network:
- default, 192.168.122.0
- _k8s_calico, no network address configured

## Create Ubuntu Template Image
```
# edit systemd-networkd-wait-online.service
/etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service

# add timeout option
ExecStart=/lib/systemd/systemd-networkd-wait-online --timeout=10

# edit netplan conf
# https://bugs.launchpad.net/netplan/+bug/1738998
/etc/netplan/00-installer-config.yaml

network:
  ethernets:
    ens3:
      dhcp6: false
      dhcp4: true
      dhcp-identifier: mac
      link-local: []
  version: 2
```

 
# run playbook with -K (become root password)


## Todo:
- use "sshpass"
- automation VM creation and setup
- automation network and IP setup
- automation ssh-copy-id


# Reference:
https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
https://computingforgeeks.com/install-cri-o-container-runtime-on-ubuntu-linux/

