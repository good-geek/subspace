
#### This script allows for mass installation and management of nodes for the Subspace test network.

#### 1. Log in to the system with root user privileges.
#### 2. Update the system.
```
apt update -y && apt install git -y
```
#### 3. Generate an SSL certificate without a password and copy it to remote servers.
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/subspace -N ""
```
#### 3. Set permission.
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
git clone https://github.com/sahalchenko/subspace
cd subspace
chmod +x subspace.sh
```
#### 6. Change your ansible hosts.yml and(or) add your nodes
```
nano ./ansible/hosts.yml
```
#### 7. Change your vars for nodes and(or) create new var files
#### change:
```ansible_host``` ```ansible_port``` ```wallet``` ```subspace_disk_size``` and other if need
```
nano ./ansible/group_vars/node1.yml
```
#### change for other node 
```
nano ./ansible/group_vars/node2.yml
```
#### or create new and change vars too. After that, don't forget to add a free node to the ./ansible/hosts.yml file.
```
cp ./ansible/group_vars/node2.yml ./ansible/group_vars/node3.yml
```
#### 8. Run script
```
./subspace.sh 
```
#### Ansible is not installed. Would you like to install it? (y/n):
#### press ```y``` and ```Enter```

#### 9. Choose node(s) for run. If select ```1``` options - All actions will be performed for all nodes.
#### 10. Select number action. Select option ```2``` for setup and upload docker compose file
#### 11. After setup run docker compose
```
./subspace.sh 
```
#### Choose node(s) for run. select ```1``` options or select other number for custom node
#### Select number action. Select option ```3```