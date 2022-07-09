echo "Script to install kubernetes for ubuntu 20.04"
echo "In 5 seconds it will begin the installation of the follow programs"
echo "hit ctrl+c to abort this operation"
echo "..."
echo -e "\n"
sleep 5

echo "droping iptables configuration!"
sudo iptables-save > ~/iptables-rules
grep -v "DROP" iptables-rules > tmpfile && mv tmpfile iptables-rules-mod
grep -v "REJECT" iptables-rules-mod > tmpfile && mv tmpfile iptables-rules-mod
sudo iptables-restore < ~/iptables-rules-mod
sudo iptables -L
sudo netfilter-persistent save
sudo systemctl restart iptables

echo "docker instalation"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "setting docker in user group"
sudo usermod -aG docker $USER

echo "cri-dockerd install"
sudo snap install --classic --channel=1.18/stable go
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
mkdir bin
VERSION=$((git describe --abbrev=0 --tags | sed -e 's/v//') || echo $(cat VERSION)-$(git log -1 --pretty='%h')) PRERELEASE=$(grep -q dev <<< "${VERSION}" && echo "pre" || echo "") REVISION=$(git log -1 --pretty='%h')
go get && go build -ldflags="-X github.com/Mirantis/cri-dockerd/version.Version='$VERSION}' -X github.com/Mirantis/cri-dockerd/version.PreRelease='$PRERELEASE' -X github.com/Mirantis/cri-dockerd/version.BuildTime='$BUILD_DATE' -X github.com/Mirantis/cri-dockerd/version.GitCommit='$REVISION'" -o cri-dockerd

echo "kubernetes installation"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "fixing bug from cri-dockerd"
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
newgrp docker
