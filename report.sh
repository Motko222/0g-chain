#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source ~/scripts/0g-chain/cfg

network=testnet
group=validator
rpc_port=$($BINARY config | jq -r .node | cut -d : -f 3)
status_json=$(curl -s localhost:$rpc_port/status | jq .result)
pid=$(pgrep $BINARY)
version=$($BINARY version)
chain=$CHAIN
foldersize1=$(du -hs $DATA | awk '{print $1}')
latest_block=$(echo $status_json | jq -r .sync_info.latest_block_height)
earliest_block_height=$(echo $status_json | jq -r .sync_info.earliest_block_height)
#network_height=$(curl -s -X POST $PUBLIC_RPC -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r '.result' | xargs printf "%d\n")
network_height=$(curl -s $PUBLIC_RPC/status | jq -r .result.sync_info.latest_block_height)
catchingUp=$(echo $status_json | jq -r .sync_info.catching_up)
node_id=$(echo $status_json | jq -r .node_info.id)@$(echo $status_json | jq -r .node_info.listen_addr)
votingPower=$($BINARY status 2>&1 | jq -r .ValidatorInfo.VotingPower)
wallet=$(echo $PASS | $BINARY keys show $KEY -a)
wallet_eth=$(echo "0x$($BINARY debug addr $(echo $PASS | $BINARY keys show $KEY -a) | grep hex | awk '{print $3}')")
valoper=$(echo $PASS | $BINARY keys show $KEY -a --bech val)
moniker=$MONIKER
pubkey=$($BINARY tendermint show-validator --log_format json | jq -r .key)
delegators=$($BINARY query staking delegations-to $valoper -o json | jq '.delegation_responses | length')
jailed=$($BINARY query staking validator $valoper -o json | jq -r .jailed)
if [ -z $jailed ]; then jailed=false; fi
tokens=$($BINARY query staking validator $valoper -o json | jq -r .tokens | awk '{print $1/1000000}' | cut -d , -f 1 )
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="'$DENOM'")' | jq -r .amount )
active=$(( $(0gchaind query tendermint-validator-set --page 1 | grep -c $pubkey ) + \
           $(0gchaind query tendermint-validator-set --page 2 | grep -c $pubkey) ))
threshold=$($BINARY query tendermint-validator-set --page 2 -o json | jq -r .validators[].voting_power | tail -1)

if $catchingUp
 then 
  status="syncing"
  message="height $latest_block/$network_height left $(( network_height - latest_block ))";
 else 
  if [ $active -eq 1 ]; 
   then status=active;message="height $latest_block/$network_height diff $(( network_height - latest_block ))";
   else status=inactive;message="height $latest_block/$network_height diff $(( network_height - latest_block ))";
 fi
fi

if $jailed
 then
  status="jailed"
  message="height $latest_block/$network_height left $(( network_height - latest_block ))";
fi 

if [ -z $pid ];
then status="offline";
 message="process not running";
fi

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
         "id":"$ID",
         "machine":"$MACHINE",
         "grp":"validator",
         "owner":"$OWNER"
  },
  "fields": {
        "version":"$version",
        "chain":"$chain",
        "status":"$status",
        "message":"$message",
        "rpcport":"$rpc_port",
        "folder1":"$foldersize1",
        "moniker":"$moniker",
        "node_id":"$node_id",
        "key":"$KEY",
        "wallet":"$wallet",
        "wallet_eth":"$wallet_eth",
        "valoper":"$valoper",
        "pubkey":"$pubkey",
        "catchingUp":"$catchingUp",
        "jailed":"$jailed",
        "active":"$active",
        "local_height":"$latest_block",
        "network_height":"$network_height",
        "earliest_block_height":"$earliest_block_height",
        "votingPower":"$votingPower",
        "tokens":"$tokens",
        "threshold":"$threshold",
        "delegators":"$delegators",
        "balance":"$balance"
  }
}
EOF

cat $json | jq
