# K8s Cluster Init Scripts (Kubeadm)

<!-- Script to initialize a K8s cluster with Kubeadm and connect worker node to master node. Uses Ubuntu 22.04 (t3.micro, 8GB volume, 0.0104USD/hr). Worker node can run on t2.micro free-tier. -->
Kubeadm scripts to initialize a k8s cluster (master and worker nodes) on Ubuntu EC2 instances. Uses flannel as the CNI plugin and installs helm.
<br />

## Ports for flannel
https://kubernetes.io/docs/reference/networking/ports-and-protocols/
<br />**Master**: 
<br />8285/UDP - flannel udp backend
<br />8472/UDP - flannel vxlan backend

<br />**Workers**:
<br />8285/UDP - flannel udp backend
<br />8472/UDP - flannel vxlan backend

## Problems
Need a way to automatically assign --apiserver-advertise-address and generate CA certificates on Master when AWS cycles through IPs after reboot.

## Resetting Master and Workers
kubeadm reset -f --cri-socket=unix:///var/run/crio/crio.sock for Master
<br />kubeadm reset -f for Worker
<br />Flush iptables if kubeadm reset -f doesn't work, also maybe remove folders and restart systemctl services
<br />https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down
<br />https://stackoverflow.com/questions/44698283/how-to-completely-uninstall-kubernetes

## Jenkins integration
To use with Jenkins outside the cluster, install Jenkins through docker 
sudo docker run -p -d 8080:8080 jenkins/jenkins (open port 8080 on aws)
<br/>Takes around 700 MB mem on standby.
<br/>For webhook, http-jenkins-ip-port/github-webhook/, Content type application/json
<br/>Dockerfile needs to match node's OS
<br/>If your services uses .env, make sure the worker node has proper IAM roles for the parameter store.
