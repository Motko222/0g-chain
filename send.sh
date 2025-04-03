#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

[ -z $1 ] && read -p "From ? " from || from=$1

wallet=$(echo $PASS | $BINARY keys show $from -a)
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="'$DENOM'")' | jq -r .amount)

echo Balance $((balance))$DENOM

def_to=$(echo $PASS | $BINARY keys show $KEY -a)
[ -z $2 ] && read -p "Send to (default $def_to) ? " to || to=$2
[ -z $to ] && to=$def_to

[ -z $3 ] && read -p "Amount ? " amount || amount=$3

#echo $PASS | $BINARY tx bank send $from $to $amount$DENOM --gas-adjustment $GAS_ADJ --gas auto -y
echo $PASS | $BINARY tx bank send $from $to $amount$DENOM --gas-adjustment $GAS_ADJ --gas $GAS --gas-prices $GAS_PRICE -y
