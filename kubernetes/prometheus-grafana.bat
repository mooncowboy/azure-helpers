helm install stable/prometheus-operator --name myprometheus --namespace monitoring --set grafana.image.tag=6.0.2 --version 6.7.3

helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring

# kubectl port-forward myprometheus-grafana-74fb5bbcf6-gsmrd -n monitoring 3000