## Kubeadm Cluster Setup Scripts

Before connecting worker and master nodes, open these inbound TCP ports ([details](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)):
Master: 
    6443 (Kubernetes API server), 
    2379-2380 (etcd server client API), 
    10250 (Kubelet API), 
    10259 (kube-scheduler), 
    10257 (kube-controller-manager)

Worker: 
    10250 (Kubelet API),
    30000-32767	(NodePort Services)
Protocol	Direction	Port Range	Purpose			        Used By
TCP		    Inbound		6443		Kubernetes API server	All
TCP		    Inbound		2379-2380	etcd server client API	kube-apiserver, etcd
TCP		    Inbound		10250		Kubelet API		        Self, Control plane
TCP		    Inbound		10259		kube-scheduler		    Self
TCP		    Inbound		10257		kube-controller-manager	Self

WORKER NODES
Protocol	Direction	Port Range	Purpose			    Used By
TCP		    Inbound		10250		Kubelet API		    Self, Control plane
TCP		    Inbound		30000-32767	NodePort Services†	All