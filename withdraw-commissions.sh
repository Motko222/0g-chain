#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

valoper=$(echo $PASS | $BINARY keys show $KEY -a --bech val)

echo $PASS | $BINARY tx distribution withdraw-rewards $valoper \
--from $KEY --commission --gas-adjustment $GAS_ADJ --gas auto -y
