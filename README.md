## Build Kubernetes Home Lab
Ansible playbooks and scripts to build kubernetes vm cluster home lab.

Follow the installation guide "deploy-kubernetes-cluster-on-ubuntu-with-kubeadm" and and make steps into Ansible playbooks. This allows simplifying and re-build the cluster.

The guides have few unclear steps and conflicts and still have to consolidate the playbooks for automation as possible.

The kubernetes cluster includes 1 master node and 4 worker nodes and is for learning purpose.


## Node Spec.
- VM: k8s-master, hostname=master, vCPU=2, Ram=8G, Disk=16G
- VM: k8s-worker-1, hostname=worker-1, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-worker-2, hostname=worker-2, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-worker-3, hostname=worker-3, vCPU=2, Ram=4G, Disk=16G
- VM: k8s-worker-4, hostname=worker-4, vCPU=2, Ram=4G, Disk=16G

- OS: Ubuntu 20.04
- Username: ubuntu
- Network: default network, 192.168.122.0


## Create Ubuntu Template Image
```
### 1. edit systemd-networkd-wait-online.service
$ vim /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service

# add timeout option
ExecStart=/lib/systemd/systemd-networkd-wait-online --timeout=10


### 2. edit netplan conf (https://bugs.launchpad.net/netplan/+bug/1738998)
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

### 3. disable auto update/upgrade
$ vim /etc/apt/apt.conf.d/20auto-upgrades

# edit file with content below
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
```


## Ansible Playbook
```
# Run playbook command
$ ansible-playbook -K <playbook filename>
``` 
> **_NOTE:_** developed with ansible version ansible 2.10.5 
>
> **_NOTE:_** run playbook with -K (become root password) up to pb.09
>
> **_NOTE:_** run playbook without -K from pb.10
>
> **_NOTE:_** ensure ansible.cfg is configured properly 

```
# ansible files naming
ansible.ad-hoc = ad-hoc shell script file
ansible.pb = playbook
ansible.tk = task list
ansible.tp = template
```


## Dashboard
```
# check the kubernetes-dashboard is NodePort type and port number
ubuntu@master:~$ kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.110.208.21   <none>        8000/TCP        14d
kubernetes-dashboard        NodePort    10.98.33.243    <none>        443:32000/TCP   14d

# create ssh port forward to access dashboard if you are not on lab node console.
# for example, in my environment, I use nuc8 as my working client, nuc10 is a physical lab server.
# all kubernetes VMs are running on the lab server. 
# 1. [local client(nuc8)] --> [lab-server(nuc10)] --> [kubernetes master VM(192.168.122.10)]
nuc8~$ ssh -N -L 32000:192.168.122.10:32000 nuc10


# 2. open url in firefox
https://localhost:32000

# 3. use the token from the output of ansible playbook 12 which create admin service account.
```


## Reinitialised master node
If master node has been re-initialised and lost all origional worker nodes.
To add worker node, the node has to be reset first. Otherwise you get error like below
```
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0506 01:15:13.238847 1419653 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /run/systemd/resolve/resolv.conf
```
To reset the worker node, run following command on worker node
```
$ kubeadm reset --force
```
Then run playbook "ansible.pb.09.add-worker-nodes.yaml" to join worker nodes.

Another workaround is run join with command with following options.
```
--ignore-preflight-errors='DirAvailable--etc-kubernetes-manifests,FileAvailable--etc-kubernetes-kubelet.conf,Port-10250,FileAvailable--etc-kubernetes-pki-ca.crt'
```


## Todo:
- automation VM creation and setup
- automation network and IP setup
- automation ssh-copy-id
- use jinja2 in manifest template
- get all manifest from download links


## Troubleshoot:
1. When add worker node and get error message "/proc/sys/net/bridge/bridge-nf-call-iptables does not exist", load "br_netfilter" kernel module. 

2. It seems like metric server and prometheus conflict each other, have to investigate their manifests.

3. When tried to delete tigera operator namespace, it stuck in "Terminating" status which is due to "metric server" issue. This need further investigation.

4. Had DNS issue inside pods. The pods count not reach kube-dns services. Didn't spent much time to troubleshoot it, so simply restart whole cluster and issue fixed.

5. Failed tasks "execcute crictl runp ansible.tp.crio.pod-network.json" in plabook 5.
```
fatal: [worker-4]: FAILED! => {
    "changed": true,
    "cmd": "crictl create d3d173762a66b1436766209ec9eed45fe54436269f774a29d95fb36c5c030fa1 crio.pod-nginx.json crio.pod-network.json\n",
    "delta": "0:00:02.013078",
    "end": "2022-07-11 01:05:40.280570",
    "rc": 1,
    "start": "2022-07-11 01:05:38.267492"
}

STDERR:

E0711 01:05:40.279672   20216 remote_runtime.go:421] "CreateContainer in sandbox from runtime service failed" err="rpc error: code = DeadlineExceeded desc = context deadline exceeded" podSandboxID="d3d173762a66b1436766209ec9eed45fe54436269f774a29d95fb36c5c030fa1"
time="2022-07-11T01:05:40+10:00" level=fatal msg="creating container: rpc error: code = DeadlineExceeded desc = context deadline exceeded"


MSG:

non-zero return code
```
It is due to http request has a deadline or timeout. 
Current solution is run playbook to each node in sequence (set playbook serial to 1) and keep re-run the playbook.


## Config Notes:
```
# metrics-server
# run "docker run --rm k8s.gcr.io/metrics-server/metrics-server:v0.6.0 --help" to get config usage.
--kubelet-use-node-status-port              Use the port in the node status. Takes precedence over --kubelet-port flag.
--kubelet-port int                          The port to use to connect to Kubelets. (default 10250)
--kubelet-insecure-tls                      Do not verify CA of serving certificates presented by Kubelets.  For testing purposes only.

```


## Knowledge Base:
```
# https://stackoverflow.com/questions/47241626/what-is-the-difference-between-kubectl-apply-and-kubectl-replace
apply --force
patch 422
delete 200
get 200
get 200
get 404
post 201

replace --force
get 200
delete 200
get 404
post 201

# https://kubernetes.io/docs/reference/kubectl/kubectl/

# https://prometheus-operator.dev/docs/prologue/quick-start/


# to allow ping in container, the container has to enable privilege in spec.

    securityContext:
      runAsUser: 0
      runAsGroup: 0
      privileged: true

Example: "ansible.tp.demo-ubuntu-pod.yaml"

# remove unused image
$ crictl rmi --prune
```


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
