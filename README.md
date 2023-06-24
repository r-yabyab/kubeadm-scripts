## Kubeadm Cluster Setup Scripts

Before connecting worker to master, open these ports:

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