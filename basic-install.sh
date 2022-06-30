#!/bin/bash
echo "Script to install traning dependency for Ubuntu 20.04"
echo "In 5 seconds it will begin the installation of the follow programs"
echo "docker"
echo "openJDK 8"
echo "maven"
echo "hit ctrl+c to abort this operation"
echo "..."
echo -e "\n"
sleep 5

echo "...begin installation..."
echo "installing docker"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt update
echo "Installing docker!\n\n"
sudo apt install -y docker-ce
echo "seting docker in user group"
sudo usermod -aG docker $USER
echo "\n\n\n\n"

#JAVA8
echo "installing openJDK8"
sudo apt install -y openjdk-8-jdk
echo "\n\n\n\n"

echo "installing maven"
sudo apt install -y maven
echo "\n\n\n\n"

echo "DONE!!!"
echo "for runing docker without sudo please exit and open the terminal again"
echo "Thank you!"
