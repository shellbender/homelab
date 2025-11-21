# Execute a command wihin a pod/container
kubectl exec configmap-example -c nginx -- cat /etc/config/conf.yml