## Kubeadm Cluster Setup Scripts

Before connecting worker and master nodes, open these inbound TCP ports ([details](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)):
<br />*Master*: 
<br />- 6443 (Kubernetes API server), 
<br />- 2379-2380 (etcd server client API), 
<br />- 10250 (Kubelet API), 
<br />- 10259 (kube-scheduler), 
<br />- 10257 (kube-controller-manager)
<br />
<br />*Worker*: 
<br />- 10250 (Kubelet API),
<br />- 30000-32767	(NodePort Services)
