#!/bin/bash

go_version=go1.22.4

sudo rm -rvf /usr/local/go/
wget https://golang.org/dl/$go_version.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf $go_version.linux-amd64.tar.gz
rm $go_version.linux-amd64.tar.gz

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

apt-get install jq unzip wget lz4 aria2 pv -y
