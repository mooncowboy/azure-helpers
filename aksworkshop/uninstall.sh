helm uninstall cert-manager --namespace cert-manager
kubectl delete ns cert-manager

helm uninstall nginx-ingress --namespace ingress
kubectl delete ns ingress

kubectl delete ns ratingsapp