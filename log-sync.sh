#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source ~/scripts/0g-chain/cfg

while true; do 
  local_height=$(0gchaind status | jq -r .sync_info.latest_block_height)
  network_height=$(curl -s $PUBLIC_RPC/status | jq -r '.result.sync_info.latest_block_height')
  blocks_left=$((network_height - local_height))

  echo -e "\033[1;33m[Sync Status]\033[0m \033[1;32mNode Height:\033[0m \033[1;37m$local_height\033[0m | \033[1;32mNetwork Height:\033[0m \033[1;37m$network_height\033[0m | \033[1;32mBlocks Left:\033[0m \033[1;31m$blocks_left\033[0m"

  sleep 5
done
