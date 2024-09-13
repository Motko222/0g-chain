#/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source ~/scripts/0g-chain/cfg
source ~/.bash_profile

#confirmation
read -p "Sure? " sure
case $sure in
 y|Y|yes|YES|Yes) ;;
 *) exit ;;
esac

#delete home folder
rm -r ~/.0gchain

#init node
$BINARY init $MONIKER --chain-id=$CHAIN --home $DATA
$BINARY config chain-id $CHAIN

# download genesis
rm ~/.0gchain/config/genesis.json
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json
0gchaind validate-genesis

#seeds and peers
SEEDS=265120a9bb170cf21198aabf88f7908c9944897c@54.241.167.190:26656,497f865d8a0f6c830e2b73009a01b3edefb22577@54.176.175.48:26656,ffc49903241a4e442465ec78b8f421c56b3ae3d4@54.193.250.204:26656,f37bc8623bfa4d8e519207b965a24a288f3213d8@18.166.164.232:26656
sed -i 's|seeds =.*|seeds = "'$SEEDS'"|g' $DATA/config/config.toml
PEERS="6dbb0450703d156d75db57dd3e51dc260a699221@152.53.47.155:13456,df4cc52fa0fcdd5db541a28e4b5a9c6ce1076ade@37.60.246.110:13456,54c269f44e1a9c3fd00fe62db52ac08e59b148f7@85.239.232.29:13456,dbfb5240845c8c7d2865a35e9f361cc42877721f@78.46.40.246:34656,386c82b09e0ec6a68e653a5d6c57f766ae73e0df@194.163.183.208:26656,d5e294d6d5439f5bd63d1422423d7798492e70fd@77.237.232.146:26656,48e3cab55ba7a1bc8ea940586e4718a857de84c4@178.63.4.186:26656,3bd6c0c825470d07cd49e57d0b650d490cc48527@37.60.253.166:26656,6efd3559f5d9d13e6442bc2fc9b17e50dc800970@91.205.104.91:13456,3b3ddcd4de429456177b29e5ca0febe4f4c21989@75.119.139.198:26656,58702cc91cc456e9beeb9b3e381f23fac39a3311@94.16.31.30:13456,e7c8f15c88ec1d6dc2b3a9ab619519fbd61182d6@217.76.54.13:26656,7e6124b7816c2fddd1e0f08bbaf0b6876230c5f4@37.27.120.13:26656,d82f58230074dccc8371f05df35c3e8d71ece034@69.67.150.107:23656,537abd857a3335e46e0f010cc01bde94854691a4@5.252.55.236:13456"
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

#min gas
#sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "$GAS_PRICE"/g' $DATA/config/app.toml
