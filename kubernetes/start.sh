sudo kubeadm init --config kubeadm-config.yaml
#sudo kubeadm init --apiserver-cert-extra-sans=$ips --pod-network-cidr=10.32.0.0/12 --control-plane-endpoint=$endPoint --upload-certs --certificate-key=$CERTKEY

#after kubernetes init
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" --output=json

#generate a new token
sudo kubeadm token create
