#!/bin/bash
#
# Setup for Control Plane (Master) servers

#for grafana

set -euxo pipefail

cd $HOME

#Install go
wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
sudo sh -c 'rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz'
# sudo sh -c 'echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile'
sudo sh -c 'echo "export PATH=\$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh'
# source /etc/profile
source /etc/profile.d/go.sh

echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.bashrc
source $HOME/.bashrc

# binary will be $(go env GOPATH)/bin/golangci-lint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.60.1


sudo apt-get install make

golangci-lint --version

sudo apt install build-essential

#to do make tests, run this
# CGO_ENABLED=1 make tests