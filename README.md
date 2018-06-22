# Multi Machine Fabric Setup: Org on each Machine

## This is a work in progress

Here are the full terminal instructions starting from a basic Ubuntu 18.04 install 

'''
sudo apt update && sudo apt upgrade
sudo apt install git make gcc g++ libltdl-dev curl python pkg-config
'''

Install Docker/ Docker Compose
'''
curl -fsSL test.docker.com | sh
sudo usermod -aG docker $USER
exec sudo su -l $USER
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
'''

Install nodejs / Composer
'''
wget https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-x64.tar.xz
tar -xf node-v8.11.2-linux-x64.tar.xz 
mv node-v8.11.2-linux-x64/ node/
echo 'export PATH=~/node/bin:$PATH' >> ~/.profile
source .profile
npm install -g npm 
npm install -g grpc
npm install -g composer-cli@0.16.6 composer-playground@0.16.6 generator-hyperledger-composer@0.16.6
'''

Install Go / Hyperledger Binaries
'''
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.10.2.linux-amd64.tar.gz
echo 'export GOPATH=/opt/go' >> ~/.profile
echo 'export GOBIN=/opt/go/bin' >> ~/.profile
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.profile
source ~/.profile
sudo mkdir -p /opt/go/bin
sudo mkdir /opt/go/src
cd $GOPATH
sudo chown -R $USER /opt/go
cd src
mkdir -p github.com/hyperledger
cd github.com/hyperledger
git clone https://gerrit.hyperledger.org/r/fabric
cd fabric
make release
'''

Download the repo for Multi Org
'''
cd ~
curl -sSL https://goo.gl/byy2Qj | bash -s 1.0.4
mkdir fabric-binaries
mv bin fabric-binaries/bin
echo 'export PATH=~/fabric-binaries/bin:$PATH' >> ~/.profile
git clone https://github.com/InflatibleYoshi/fabric-dev-servers-multipeer
cd fabric-dev-servers-multipeer
cd composer
'''

change configtx.yaml to have the ip of the 1st peer in the orderer
change startFabric-peer2 in exec change orderer.example.com to ip of 1st peer
