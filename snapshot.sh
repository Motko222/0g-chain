#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

read -p "Are you sure? " sure
case $sure in
 y|Y|yes|YES|Yes) ;;
 *) exit ;;
esac

pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.0gchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.0gchain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.0gchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.0gchain/config/app.toml

sudo systemctl stop $BINARY.service

cp ~/.0gchain/data/priv_validator_state.json ~/.0gchain/priv_validator_state.json.backup

0gchaind tendermint unsafe-reset-all --home ~/.0gchain --keep-addr-book
curl https://snapshots-testnet.unitynodes.com/0gchain-testnet/0gchain-testnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.0gchain

mv ~/.0gchain/priv_validator_state.json.backup ~/.0gchain/data/priv_validator_state.json

sudo systemctl start $BINARY.service
sudo journalctl -u $BINARY.service -f --no-hostname -o cat
