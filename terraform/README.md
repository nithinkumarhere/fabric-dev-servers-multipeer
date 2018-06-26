# Terraform Install

You should be able to deploy main.tf without any difficulty unless you do not have a public_key as ~/.ssh/id_rsa.pub. That should be the only thing you need to change in order to access the instances using public_key authentication.

```
terraform init
terraform plan
terraform apply
```

SSH into both instances with
```
ssh ubuntu@'hostnameofAWSEC2instance'
cd fabric-dev-servers-multipeer
```

On the machine 'ubuntu@192.168.1.222' run:
```
./startFabric.sh
```

On the machine 'ubuntu@192.168.1.224' run:
```
./startFabric-Peer2.sh
```

On the machine 'ubuntu@192.168.1.222' run:
```
./createPeerAdminCard.sh
nohup composer-playground &
```

You will find composer at the Hostname of the instance you ran composer playground on at hostnameofAWSEC2instance:8080.