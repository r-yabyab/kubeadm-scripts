## Kubeadm Cluster Setup Scripts

Forked repo that lets you initialize a K8 cluster with Kubeadm in an Ubuntu 22.04 instance (t3.micro, 8gb volume, 0.0104USD/hr). Worker node can run on t2.micro free-tier.
<br />

Before connecting worker and master nodes, open these inbound TCP ports ([details](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)):
<br />**Master**: 
<br />6443 (Kubernetes API server), 
<br />2379-2380 (etcd server client API), 
<br />10250 (Kubelet API), 
<br />10259 (kube-scheduler), 
<br />10257 (kube-controller-manager)
<br />
<br />**Worker**: 
<br />10250 (Kubelet API),
<br />30000-32767	(NodePort Services)
<br />
<br /> Works with the latest K8 version (1.27.3). v1.26 is specified to download cri-o.