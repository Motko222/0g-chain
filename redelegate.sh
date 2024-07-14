#!/bin/bash

#usage: bash delegate.sh <key> <valoper> <amount>

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

[ -z $1 ] && read -p "From ($KEY) ? " key || key=$1
[ -z $key ] && key=$KEY

wallet=$(echo $PASS | $BINARY keys show $key -a)
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null | jq -r '.balances[] | select(.denom=="'$DENOM'")' | jq -r .amount)
echo "Balance: $balance $DENOM"

def_valoper=$(echo $PASS | $BINARY keys show $KEY -a --bech val)
[ -z $2 ] && read -p "From valoper (default $def_valoper) ? " from_valoper || from_valoper=$2
[ -z $from_valoper ] && from_valoper=$def_valoper

[ -z $3 ] && read -p "To valoper ? " to_valoper || to_valoper=$3

[ -z $4 ] && read -p "Amount ? " amount || amount=$4

echo $PASS | $BINARY tx staking redelegate $from_valoper $to_valoper $amount$DENOM --from $key \
 --gas-adjustment $GAS_ADJ --gas auto -y
