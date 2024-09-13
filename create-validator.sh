#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

#create validator
echo $PASS | $BINARY tx staking create-validator \
  --amount=1000000$DENOM \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=zgtendermint_16600-2\
  --commission-rate=0.05 \
  --commission-max-rate=0.10 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1 \
  --from=$KEY \
  --website=$WEBSITE \
  --details="$DETAILS" \
  --gas=auto --gas-adjustment=1.4 \
  -y
