## Build Kubernetes Home Lab
Ansible playbooks and scripts to build kubernetes vm cluster in my home lab.
The kubernetes cluster includes 1 master node and 3 worker nodes.


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
# 1. edit systemd-networkd-wait-online.service
$ vim /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service

# add timeout option
ExecStart=/lib/systemd/systemd-networkd-wait-online --timeout=10


# 2. edit netplan conf (https://bugs.launchpad.net/netplan/+bug/1738998)
$ vim /etc/netplan/00-installer-config.yaml

# edit the first interface to use "mac" as dhcp-identifier.
network:
  ethernets:
    ens3:
      dhcp6: false
      dhcp4: true
      dhcp-identifier: mac
      link-local: []
  version: 2
```


## Ansible Playbook
```
# Run playbook command
$ ansible-playbook <playbook filename> -K 
``` 
> **_NOTE:_** run playbook with -K (become root password) 
> **_NOTE:_** ensure ansible.cfg is configured properly

```
# ansible files naming
ansible.ad-hoc = ad-hoc shell script file
ansible.pb = playbook
ansible.tk = task list
ansible.tp = template
```

## Todo:
- use "sshpass" to templating VM image
- automation VM creation and setup
- automation network and IP setup
- automation ssh-copy-id


## Troubleshoot:
1. When add worker node and get error message "/proc/sys/net/bridge/bridge-nf-call-iptables does not exist", load "br_netfilter" kernel module. 


## Reference:
https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
https://computingforgeeks.com/install-cri-o-container-runtime-on-ubuntu-linux/
https://stackoverflow.com/questions/51126164/how-do-i-find-the-join-command-for-kubeadm-on-the-master
https://stackoverflow.com/questions/33896847/how-do-i-set-register-a-variable-to-persist-between-plays-in-ansible
https://jhooq.com/amp/kubernetes-error-execution-phase-preflight-preflight/


## Issue reference:
https://github.com/cri-o/cri-o/issues/5490
https://github.com/cri-o/cri-o/issues/3259
https://githubhot.com/repo/tigera/operator/issues/1780
