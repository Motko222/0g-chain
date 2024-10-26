#!/bin/bash

#usage: bash delegate.sh <key> <valoper> <amount>

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

[ -z $1 ] && read -p "From ($KEY) ? " key || key=$1
[ -z $key ] && key=$KEY

wallet=$(echo $PASS | $BINARY keys show $key -a)
$BINARY query staking delegations $wallet -o json | jq -c -r '.delegation_responses[] |  [ .delegation.validator_address, .balance.amount ]' | sed 's/\"\|\[\|\]//g' | sed 's/,/   /g'
[ -z $2 ] && read -p "From valoper ? " from_valoper || from_valoper=$2
[ -z $3 ] && read -p "Amount ? " amount || amount=$3

echo $PASS | $BINARY tx staking unbond $from_valoper $amount$DENOM --from $key \
 --gas-adjustment $GAS_ADJ --gas auto -y
