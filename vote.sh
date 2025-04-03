#!/bin/bash

#usage: bash vote.sh <key> <proposal> <option>

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

[ -z $1 ] && read -p "From ($KEY) ? " key || key=$1
[ -z $key ] && key=$KEY

$BINARY query gov proposals --status voting_period -o json | jq -r '.proposals[] | {id,title}'

[ -z $2 ] && read -p "Proposal ? " proposal || proposal=$2

[ -z $3 ] && read -p "Option (YES/no/nowithveto/abstain) ? " option || option=$3
[ -z $option ] && option=yes

#echo $PASS | $BINARY tx gov vote $proposal $option --from $key --gas-adjustment $GAS_ADJ --gas auto -y
echo $PASS | $BINARY tx gov vote $proposal $option --from $key --gas-adjustment $GAS_ADJ --gas $GAS --gas-prices $GAS_PRICE -y
