#!/bin/bash

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')

#remove service
sudo systemctl stop 0gchaind
sudo systemctl disable 0gchaind
rm /etc/systemd/system/0gchaind.service

#backup keys and config
rm -r /root/backup/0g-chain
mkdir /root/backup/0g-chain
cp /root/.0gchain/config /root/backup/0g-chain
mkdir /root/backup/0g-chain/data
cp /root/.0gchain/data/*.json /root/backup/0g-chain/data

#remove folder
#rm -r /root/.0gchain
#rm -r /root/0g-chain

#backup and remove scripts
rm -r /root/scripts/$folder/.git
rm -r /root/backup/scripts/$folder
mv -f /root/scripts/$folder /root/backup/scripts

source /root/scripts/0g-chain/cfg
echo $ID | bash /root/scripts/system/influx-delete-id.sh

