#!/bin/bash

while true; do 
  local_height=$(0gchaind status | jq -r .sync_info.latest_block_height)
  network_height=$(curl -s https://rpc.0gchain-testnet.unitynodes.com/status | jq -r '.result.sync_info.latest_block_height')
  blocks_left=$((network_height - local_height))

  echo -e "\033[1;33m[Sync Status]\033[0m \033[1;32mNode Height:\033[0m \033[1;37m$local_height\033[0m | \033[1;32mNetwork Height:\033[0m \033[1;37m$network_height\033[0m | \033[1;32mBlocks Left:\033[0m \033[1;31m$blocks_left\033[0m"

  sleep 5
done
