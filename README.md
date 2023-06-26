## K8s Cluster Init Scripts (Kubeadm)

<!-- Script to initialize a K8s cluster with Kubeadm and connect worker node to master node. Uses Ubuntu 22.04 (t3.micro, 8GB volume, 0.0104USD/hr). Worker node can run on t2.micro free-tier. -->
Script to initialize a K8s cluster with Kubeadm and connect worker node to master node. Uses Ubuntu 22.04 (t3.small, 10GB volume, 0.0204USD/hr). Worker node can run on t2.micro free-tier.
<br />

Before connecting worker and master nodes, open these inbound TCP ports ([details](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)):
<br />**Master**: 
<br />6443 (Kubernetes API server), 
<br />2379-2380 (etcd server client API), 
<br />10250 (Kubelet API), 
<br />10259 (kube-scheduler), 
<br />10257 (kube-controller-manager)
<br />*179 (Calico nodes)*
<br />
<br />**Worker**: 
<br />10250 (Kubelet API),
<br />30000-32767	(NodePort Services)
<br />
<br /> Works with the latest K8s version (1.27.3). 
<br />kube-controller-manager & kube-scheduler will go into CrashLoopBackOff occasionally if Mem requirement isn't met.

<br />Other commands:
<br />Check availability:
<br />- kubectl get po -n kube-system
<br />- kubectl get --raw='/readyz?verbose'

<br />Check Resources:
<br />Mem:
<br />- free -h
<br />Vol:
<br />- df -h
<br />
<br />Vol after setup: 3.8GB master, 3.6GB worker

<br />Use elastic IP if you don't wanna recertify new addresses on instance reboot.