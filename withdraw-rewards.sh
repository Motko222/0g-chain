#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

read -p "Key? " key

echo $PASS | $BINARY tx distribution withdraw-all-rewards --from $key --gas-adjustment $GAS_ADJ --gas $GAS --gas-prices $GAS_PRICE -y
