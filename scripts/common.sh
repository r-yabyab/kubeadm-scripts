#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

set -euxo pipefail

# Variable Declaration

# KUBERNETES_VERSION="1.26.1-00"
# KUBERNETES_VERSION="1.27.3"
# KUBERNETES_VERSION="1.29.2"
KUBERNETES_VERSION=v1.31
CRIO_VERSION=v1.30

# disable swap
sudo swapoff -a

# keeps the swap off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y


# Install CRI-O Runtime
OS="xUbuntu_24.04"


# VERSION="$(echo ${KUBERNETES_VERSION} | grep -oE '[0-9]+\.[0-9]+')"

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

#### Deprecated
# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
# deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
# EOF
# cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:"$VERSION".list
# deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
# EOF

# curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:"$VERSION"/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
# curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

sudo apt-get update
#maybe not this one vv
# sudo apt-get install -y software-properties-common curl
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# mkdir /etc/apt/keyrings

# below outdated
# sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key |
#     sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# sudo echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" |
#     sudo tee /etc/apt/sources.list.d/kubernetes.list

# current vers
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list


curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

# exit

sudo apt-get update
sudo apt-get install -y cri-o kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# sudo apt-get install cri-o cri-o-runc -y

# sudo systemctl daemon-reload
# sudo systemctl enable crio --now

# Master kubelet & cri-o are systemd by default.
echo "CRI runtime installed susccessfully"

sudo systemctl start crio.service

# Install kubelet, kubectl and Kubeadm

# sudo apt-get update -y
# # sudo apt-get install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
# sudo apt-get install -y kubelet kubeadm kubectl

# sudo apt-mark hold kubelet kubeadm kubectl
sudo apt-get update -y
sudo apt-get install -y jq

# NEED TO CHANGE TO IP ROUTE PRIVATE IP
# local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
local_ip="$(hostname | grep -o '[^ip-].*' | tr '-' '.')"

#run this with sudo su
sudo su -c "cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF"

exit