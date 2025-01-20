#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/.bash_profile

read -p "Tag? (https://github.com/0glabs/0g-chain/releases) " tag

#install binary by build
#cd ~
#git clone -b $tag https://github.com/0glabs/0g-chain.git
#./0g-chain/networks/testnet/install.sh
#source ~/.profile

#Install binary by download
cd /root/go/bin
rm 0gchaind
wget https://github.com/0glabs/0g-chain/releases/download/$tag/0gchaind-linux-$tag
cp 0gchaind-linux-$tag 0gchaind
chmod +x 0gchaind

#create cfg file
if [ -f ~/scripts/$folder/cfg ]
then
 echo "Config exists."
else
 cp ~/scripts/$folder/cfg.sample ~/scripts/$folder/cfg
 nano ~/scripts/$folder/cfg
fi

source ~/scripts/$folder/cfg

#check version
$BINARY version



