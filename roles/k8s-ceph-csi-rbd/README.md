#### Ceph-CSI rbd driver

This role deploys Ceph-CSI rbd driver into the kubernetes cluster.

Ceph Cluster must have "pool" and "user" created for the Kubernetes to create and consume RBD volume.

Update defaults/main.yaml file for use in your environment.



#### Tags
There are two tags used in the role. "deploy" and "pvc_test" tags
The "deploy" tag indicates all tasks for deploy Ceph CSI RBD driver.
The "pvc_test" tag only creates a pvc and then delete for testing.

To deploy without pvc test
```
$ ansible-playbook ansible.pb.extra.setup-ceph-csi-rbd.yaml --tags deploy
```
To run pvc test
```
$ ansible-playbook ansible.pb.extra.setup-ceph-csi-rbd.yaml --tags pvc_test
```

```
$ ansible-playbook ansible.pb.extra.setup-ceph-csi-rbd.yaml --tags pvc_test
 
PLAY [Setup Ceph CSI RBD driver] *****************************************************************************************

TASK [k8s-ceph-csi-rbd : copy ceph csi rbd pvc test manifest] ************************************************************
ok: [master]

TASK [k8s-ceph-csi-rbd : create ceph csi test pvc] ***********************************************************************
changed: [master]

TASK [k8s-ceph-csi-rbd : wait for 10 seconds] ****************************************************************************
ok: [master]

TASK [k8s-ceph-csi-rbd : check ceph csi test pvc] ************************************************************************
changed: [master]

TASK [k8s-ceph-csi-rbd : print ceph csi test pvc] ************************************************************************
ok: [master] => {}

MSG:

NAME                    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
ceph-csi-rbd-pvc-test   Bound    pvc-2a6a9d3f-2be3-4c80-97c6-f0fbde04d760   1Gi        RWO            ceph-csi-rbd   11s

TASK [k8s-ceph-csi-rbd : delete ceph csi test pvc] ***********************************************************************
changed: [master]

PLAY RECAP ***************************************************************************************************************
master                     : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

#### Expect PVC test
The pvc test print pvc status in ansible tasks. 
With successful install of Ceph CSI RBD driver, the "STATUS" of the pvc should be "Bound".