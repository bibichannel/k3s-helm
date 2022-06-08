echo "***---GET TOKEN MASTER NODE---***"
echo "Token: sudo cat /var/lib/rancher/k3s/server/node-token" 
sudo cat /var/lib/rancher/k3s/server/node-token

echo "\n\n***---UNINSTALL K3S---***"
echo "Uninstall k3s : /usr/local/bin/k3s-agent-uninstall.sh"

echo "\n\n***---INSTALL WORKER NODE WITH COMMANDS---***"
echo "export K3S_URL=\"https://$(hostname -I | awk '{print $1}'):6443\""
echo "export K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)"
