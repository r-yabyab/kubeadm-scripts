#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

# If you need public access to API server using the servers Public IP adress, change PUBLIC_IP_ACCESS to true.

# PUBLIC_IP_ACCESS="false"
NODENAME=$(hostname -s)
# POD_CIDR="192.168.0.0/16"
# FLANNEL_CIDR
POD_CIDR="10.244.0.0/16"
# CALICO_CIDR
# POD_CIDR="192.168.0.0/16"

# Pull required images

# sets back to k8s vers 1.8... look into this bc it makes metrics lost on cni bridge
#probably dont need because images are pulled on kubeadm init
# https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/
# sudo kubeadm config images pull

# Initialize kubeadm based on PUBLIC_IP_ACCESS

# if [[ "$PUBLIC_IP_ACCESS" == "false" ]]; then
    
    # MASTER_PRIVATE_IP=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
sudo kubeadm init --apiserver-advertise-address="$local_ip" --apiserver-cert-extra-sans="$local_ip" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap
    # sudo kubeadm init --apiserver-advertise-address="$MASTER_PRIVATE_IP" --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" --pod-network-cidr=10.244.0.0/16 --node-name "$NODENAME" --ignore-preflight-errors Swap

# elif [[ "$PUBLIC_IP_ACCESS" == "true" ]]; then

#     MASTER_PUBLIC_IP=$(curl ifconfig.me && echo "")
#     sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap
#     # sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors=Mem,Swap
# else
#     echo "Error: MASTER_PUBLIC_IP has an invalid value: $PUBLIC_IP_ACCESS"
#     exit 1
# fi

# Configure kubeconfig

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

# # curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
# curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml -O

# CALICO CNI 
# documentation https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
# kubectl apply -f calico.yaml
# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml
# kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# kubectl taint nodes --all node-role.kubernetes.io/master-


# FLANNEL CNI
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# sync flannel and cni0 inet addresses
sudo ip link delete cni0 type bridge

# RESTART COREDNS PODS
# kubectl delete po -n kube-system $(kubectl get pods -n kube-system | grep coredns | awk '{print $1}') --now
kubectl delete pod -n kube-system -l k8s-app=kube-dns

    ## if coredns gets stuck on containerCreating, delete bridge again

# then join workers

#if running only master node
#kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-

#helm install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#more /etc/hosts

# change kubernetes-dashboard-kong-proxy svc from ClusterIP to NodePort 
# then use worker node's ip and kong-proxy port (not 8443 or 443, 
# don't need to port forward even if it instructs you to)

    # if still can't connect via kong-proxy, restart coreDNS pods. Works with or without Flannel

#Create service account for dashboard login
#https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md


#cmds
# kubectl get svc -n kubernetes-dashboard
# kubectl edit svc kubernetes-dashboard-kong-proxy -n kubernetes-dashboard
    # change ClusterIP to NodePort

#when change values.yaml
# helm upgrade kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
# --namespace kubernetes-dashboard \
# --values /path/to/your/modified/values.yaml