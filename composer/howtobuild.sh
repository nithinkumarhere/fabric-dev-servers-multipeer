cd "$(dirname "$0")"

HOST1="35.202.81.248"
HOST2="34.73.154.41"
HOST3="35.245.145.188"
HOST4="35.230.15.160"
HOST5="35.236.59.78"

sed -i -e "s/{IP-HOST-1}/$HOST1/g" configtx.yaml
sed -i -e "s/{IP-HOST-1}/$HOST1/g" ../startFabric-Peer2.sh
sed -i -e "s/{IP-HOST-1}/$HOST1/g" ../startFabric-Peer3.sh
sed -i -e "s/{IP-HOST-1}/$HOST1/g" ../startFabric-Peer4.sh
sed -i -e "s/{IP-HOST-1}/$HOST1/g" ../startFabric-Peer5.sh
sed -i -e "s/{IP-HOST-2}/$HOST2/g" ../createPeerAdminCard.sh
sed -i -e "s/{IP-HOST-3}/$HOST3/g" ../createPeerAdminCard.sh
sed -i -e "s/{IP-HOST-4}/$HOST4/g" ../createPeerAdminCard.sh
sed -i -e "s/{IP-HOST-5}/$HOST5/g" ../createPeerAdminCard.sh

~/fabric-binaries/bin/cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD
~/fabric-binaries/bin/configtxgen -profile ComposerOrdererGenesis -outputBlock ./composer-genesis.block
~/fabric-binaries/bin/configtxgen -profile ComposerChannel -outputCreateChannelTx ./composer-channel.tx -channelID composerchannel

ORG1KEY="$(ls crypto-config/peerOrganizations/org1.example.com/ca/ | grep 'sk$')"
ORG2KEY="$(ls crypto-config/peerOrganizations/org2.example.com/ca/ | grep 'sk$')"
ORG3KEY="$(ls crypto-config/peerOrganizations/org3.example.com/ca/ | grep 'sk$')"
ORG4KEY="$(ls crypto-config/peerOrganizations/org4.example.com/ca/ | grep 'sk$')"
ORG5KEY="$(ls crypto-config/peerOrganizations/org5.example.com/ca/ | grep 'sk$')"

sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" docker-compose.yml
sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" docker-compose-peer2.yml
sed -i -e "s/{ORG3-CA-KEY}/$ORG3KEY/g" docker-compose-peer3.yml
sed -i -e "s/{ORG3-CA-KEY}/$ORG4KEY/g" docker-compose-peer4.yml
sed -i -e "s/{ORG3-CA-KEY}/$ORG5KEY/g" docker-compose-peer5.yml

