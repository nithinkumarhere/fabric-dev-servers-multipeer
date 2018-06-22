#!/bin/bash

# Exit on first error
set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo
# check that the composer command exists at a version >v0.14
if hash composer 2>/dev/null; then
    composer --version | awk -F. '{if ($2<15) exit 1}'
    if [ $? -eq 1 ]; then
        echo 'Sorry, Use createConnectionProfile for versions before v0.15.0' 
        exit 1
    else
        echo Using composer-cli at $(composer --version)
    fi
else
    echo 'Need to have composer-cli installed at v0.15 or greater'
    exit 1
fi
# need to get the certificate 

cat << EOF > /tmp/.connection.json
{
    "name": "hlfv1",
    "type": "hlfv1",
    "orderers": [
       { "url" : "grpc://localhost:7050" }
    ],
    "ca": { 
        "url": "http://localhost:7054", 
        "name": "ca.org1.example.com"
    },
    "peers": [
        {
            "requestURL": "grpc://localhost:7051",
            "eventURL": "grpc://localhost:7053"
        }, {
            "requestURL": "grpc://localhost:8051",
            "eventURL": "grpc://localhost:8053"
        }, {
            "requestURL": "grpc://localhost:9051",
            "eventURL": "grpc://localhost:9053"
        }
    ],
    "channel": "composerchannel",
    "mspID": "Org1MSP",
    "timeout": 300
}
EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/45a252aeab4a5bf23deed32cd858d5c52001eceb45be77d011cd34aa6776cd0a_sk
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem

if composer card list -n Org1@hlfv1 > /dev/null; then
    composer card delete -n Org1@hlfv1
fi
composer card create -p /tmp/.connection.json -u Org1 -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/Org1@hlfv1.card
composer card import --file /tmp/Org1@hlfv1.card 

rm -rf /tmp/.connection.json

cat << EOF > /tmp/.connection.json
{
    "name": "hlfv1",
    "type": "hlfv1",
    "orderers": [
       { "url" : "grpc://localhost:7050" }
    ],
    "ca": { 
        "url": "http://localhost:7054", 
        "name": "ca.org2.example.com"
    },
    "peers": [
        {
            "requestURL": "grpc://192.168.1.224:10051",
            "eventURL": "grpc://192.168.1.224:10053"
        }, {
            "requestURL": "grpc://192.168.1.224:11051",
            "eventURL": "grpc://192.168.1.224:11053"
        }, {
            "requestURL": "grpc://192.168.1.224:12051",
            "eventURL": "grpc://192.168.1.224:12053"
        }
    ],
    "channel": "composerchannel",
    "mspID": "Org2MSP",
    "timeout": 300
}
EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/97c37ad380aaafbb7677901f3d50818dca81e5de4b74417d2709a7f7cd3c8822_sk
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/Admin@org2.example.com-cert.pem

if composer card list -n Org2@hlfv1 > /dev/null; then
    composer card delete -n Org2@hlfv1
fi
composer card create -p /tmp/.connection.json -u Org2 -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/Org2@hlfv1.card
composer card import --file /tmp/Org2@hlfv1.card 

rm -rf /tmp/.connection.json


echo "Hyperledger Composer PeerAdmin card has been imported"
composer card list

