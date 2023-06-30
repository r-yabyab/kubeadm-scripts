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
<br />*8080 (optional Jenkins)*
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

<br />CA Certificates are generated on cluster init. Use AWS elastic IP to keep k8s running on reboot. A stopped instance with an elastic IP with incur $0.005/hr

<br/>To use with Jenkins outside the cluster, install Jenkins through docker 
sudo docker run -p -d 8080:8080 jenkins/jenkins
<br/>Takes around 700 MB mem on standby.
<br/>**Dockerfile needs to match node's OS**
<br/>If your services uses .env, make sure the worker node has proper IAM roles for the paramter store.