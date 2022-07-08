ips=$1
endPoint=$2

if [ -z $ips ] || [ -z $endPoint ] ; then
  echo "Inform the ips and endPoint"
  echo "ex: .\start.sh xx.xx.xx.xx,xx.xx.xx.xx zz.zz.zz.zz"
else
  CERTKEY=$(kubeadm certs certificate-key)
  echo $CERTKEY &> certkey.key
  echo "trying to setting up kubernet cluster with apiserver="$ips" and endpoint="$endPoint
  sudo kubeadm init --config kubeadm-config.yaml --apiserver-cert-extra-sans=$ips --pod-network-cidr=10.32.0.0/12 --control-plane-endpoint=$endPoint --upload-certs --certificate-key=$CERTKEY &> kube_out_cp.info
fi
