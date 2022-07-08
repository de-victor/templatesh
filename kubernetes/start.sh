#! /bin/sh

endPoint=$1
file=kubeadm-config.yaml

if [ -z $endPoint ] ; then
  echo "Inform endPoint"
  echo "ex: .\start.sh xx.xx.xx.xx"
else
  #modify config yaml
  sed -i 's/controlPlaneEndpoint:.*/controlPlaneEndpoint: '$endPoint'/' $file

  #start kubernet control panel
  sudo kubeadm init --config kubeadm-config.yaml

  #after kubernetes init
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  #seting pods network
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" --output=json

  #generate a new token
  sudo kubeadm token create
fi
