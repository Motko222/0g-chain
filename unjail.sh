#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

echo $PASS | $BINARY tx slashing unjail --from $KEY --gas-adjustment $GAS_ADJ --gas $GAS --gas-prices $GAS_PRICE -y
