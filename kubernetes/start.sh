ips = $1
endPoint = $2
CERTKEY=$(kubeadm certs certificate-key)
echo $CERTKEY
echo "trying to setting up kubernet cluster with apiserver="$ips" and endpoint="$endPoint

sudo kubeadm init --config kubeadm-config.yaml --apiserver-cert-extra-sans=$ips --pod-network-cidr=10.32.0.0/12 --control-plane-endpoint=$endPoint --upload-certs --certificate-key=$CERTKEY
