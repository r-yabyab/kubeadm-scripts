## K8s Cluster Init Scripts (Kubeadm)

<!-- Script to initialize a K8s cluster with Kubeadm and connect worker node to master node. Uses Ubuntu 22.04 (t3.micro, 8GB volume, 0.0104USD/hr). Worker node can run on t2.micro free-tier. -->
Scripts to initialize a k8s cluster with Kubeadm, works with k8s version 1.29.1. Master runs on Ubuntu 22.04, t3.small, 10GB volume. Worker node runs on t3.micro.
Master kubelet & cri-o are already set to systemd.
<br />

# Ports needed before initialization
Before connecting worker and master nodes, open these inbound TCP ports ([details](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)):
<br />**Master**: 
<br />6443 (Kubernetes API server), 
<br />2379-2380 (etcd server client API), 
<br />10250 (Kubelet API), 
<br />10259 (kube-scheduler), 
<br />10257 (kube-controller-manager)
<br />*179 (Calico nodes)*
<br />*8080 (optional Jenkins)*
<br />
<br />**Worker**: 
<br />10250 (Kubelet API),
<br />30000-32767	(NodePort Services)
<br />

<br />Check Resources:
<br />Mem:
<br />- free -h
<br />Vol:
<br />- df -h
<br />kubectl config view
<br />Vol after setup: 3.8GB master, 3.6GB worker

# Problems
- Need a way to automatically assign --apiserver-advertise-address and generate CA certificates on Master when AWS cycles through IPs after reboot.

# Resetting Master and Workers
<br />kubeadm reset -f --cri-socket=unix:///var/run/crio/crio.sock for Master
<br />kubeadm reset -f for Worker
<br />Flush iptables if kubeadm reset -f doesn't work, also maybe remove folders and restart systemctl services
<br />https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down
<br />https://stackoverflow.com/questions/44698283/how-to-completely-uninstall-kubernetes

<br/>To use with Jenkins outside the cluster, install Jenkins through docker 
sudo docker run -p -d 8080:8080 jenkins/jenkins
<br/>Takes around 700 MB mem on standby.
<br/>For webhook, http-jenkins-ip-port/github-webhook/, Content type application/json
<br/>**Dockerfile needs to match node's OS**
<br/>If your services uses .env, make sure the worker node has proper IAM roles for the parameter store.

<br/>
<br/>Why is any of this needed? To avoid Amazon's $0.10/hr for EKS which still requires you to spin up linux instances.
