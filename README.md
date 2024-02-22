
#### This script allows for mass installation and management of nodes for the Subspace test network.

#### 1. Log in to the system with root user privileges.
#### 2. Update the system.
```
apt update -y 
```
#### 3. Generate an SSL certificate without a password and copy it to remote servers.
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/subspace -N ""
```
#### 3. Setting permissions for our certificates.
```
chmod 0600 ~/.ssh/subspace.pub
```
#### 4. Copy pub ssh-rsa to remote server
#### where ```-p``` your ssh port and ``` REMOTE_IP ``` your IP remote node
```
ssh-copy-id -i ~/.ssh/subspace.pub -p 9778 root@REMOTE_IP
```
#### 5. Clone subspace script and cd your work dir
```
git clone ...........
cd ...........
chmod +x 
```
#### 6. Change your ansible hosts.yml and(or) add your nodes
```
./ansible/hosts.yml
```
#### 7. Change your vars for nodes and(or) create new var files
```
nano ./ansible/group_vars/node1.yml
```


