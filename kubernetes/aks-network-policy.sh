# FROM https://www.danielstechblog.io/kubernetes-network-policies-on-azure-kubernetes-service-with-azure-npm/
kubectl apply -f https://raw.githubusercontent.com/Azure/acs-engine/master/parts/k8s/addons/kubernetesmasteraddons-azure-npm-daemonset.yaml
kubectl get pods -n kube-system --selector=k8s-app=azure-npm -o wide