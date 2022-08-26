#!/bin/bash

set -e

#The first line specifies in which mode we would like to write the k3s configuration (required when not running commands as root)
export K3S_KUBECONFIG_MODE="644"
#the second line actually says k3s not to deploy its default load balancer named servicelb and proxy traefik, instead we will install manually metalb as load balancer and nginx as proxy which are in my opinion better and more widely used.
export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik"

# Install control plane of kubernetes cluster: k3s
curl -sfL https://get.k3s.io | sh -
kubectl config view --raw > ~/.kube/config

# Install package manager of kubernetes: helm 3
echo "\n\n***---INSTALL HELM  3---***"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Install loadbalancer: metallb 
helm repo add stable https://charts.helm.sh/stable
helm repo update

export filename=values.yaml
cat << EOF > $filename
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 192.168.0.240-192.168.0.250
EOF

helm upgrade --install --debug --namespace kube-system metallb stable/metallb -f values.yaml

# Install ingress nginx
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace --debug

echo "-----------------------------------------------------------"
echo "=>> 'Control plane' has been installed in the current Node!"
echo "=>> 'Helm 3' has been installed in the current Node!"
echo "=>> 'Metallb' has been installed in the current Node!"
echo "=>> 'Ingress nginx' has been installed in the current Node!"
echo "-----------------------------------------------------------"
echo
echo "Run file 'infoCommand.sh' for the next step!"

