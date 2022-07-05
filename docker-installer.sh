#!/bin/bash

programs=("docker-ce" "docker-compose")

echo "Script to install traning dependency for Ubuntu 20.04"
echo "In 5 seconds it will begin the installation of the follow programs"
for i in ${programs[@]}
do
  echo $i
done
echo "hit ctrl+c to abort this operation"
echo "..."
echo -e "\n"
sleep 5

echo "setup"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt update

echo "start installation"
for i in ${programs[@]}
do
  echo "installing $i now"
  sudo apt install -y $i
done

echo "pos installation"
echo "setting docker in user group"
sudo usermod -aG docker $USER

echo "droping iptables configuration"
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F
sudo iptables --flush

echo "DONE!!!"
echo "for runing docker without sudo please exit and open the terminal again"
echo "Thank you!"
