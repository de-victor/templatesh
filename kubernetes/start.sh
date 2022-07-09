#! /bin/sh

endPoint=$1
localApi=$2
file=kubeadm-config.yaml

if [ -z $endPoint ] || [ -z $localApi ] ; then
  echo "Inform endPoint and localApi"
  echo "ex: .\start.sh 192.0.7.41 10.0.2.01"
else
  #modify config yaml
  sed -i 's/controlPlaneEndpoint:.*/controlPlaneEndpoint: '$endPoint'/' $file
  sed -i 's/advertiseAddress:.*/advertiseAddress: '$localApi'/' $file

  #start kubernet control panel
  sudo kubeadm init --config kubeadm-config.yaml --upload-certs

  #after kubernetes init
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  #seting pods network
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

fi
