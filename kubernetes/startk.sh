#! /bin/sh

endPoint=$1
othersIp=$2

if [ -z $endPoint ] || [ -z $othersIp ] ; then
  echo "Inform endPoint and others ip"
  echo "ex: .\start.sh 192.0.7.41 10.0.0.1,192.10.04.1"
else
  
  #start kubernet control panel
  CERTKEY=$(kubeadm certs certificate-key)
  echo $CERTKEY
  
  sudo kubeadm init --apiserver-cert-extra-sans=$othersIp --pod-network-cidr=10.32.0.0/12 --control-plane-endpoint=$endPoint --upload-certs --certificate-key=$CERTKEY

  #after kubernetes init
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  #seting pods network
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

fi
