#!/bin/bash

#The first line specifies in which mode we would like to write the k3s configuration (required when not running commands as root)
export K3S_KUBECONFIG_MODE="644"
#the second line actually says k3s not to deploy its default load balancer named servicelb and proxy traefik, instead we will install manually metalb as load balancer and nginx as proxy which are in my opinion better and more widely used.
export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik"

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Install helm 3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "Token: sudo cat /var/lib/rancher/k3s/server/node-token" 
sudo cat /var/lib/rancher/k3s/server/node-token

echo "Uninstall k3s : /usr/local/bin/k3s-agent-uninstall.sh"

echo "Install worker node with commands"
echo "export K3S_URL=\"https://$(hostname -I | awk '{print $1}'):6443\""
echo "export K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)"
