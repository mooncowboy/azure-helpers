set -e

source .env

ISSUER_EMAIL=${1:-$ISSUER_EMAIL}
if [ -z $ISSUER_EMAIL ]; then
    echo "Need a valid email for cluster issuer"
    exit 1
fi

kubectl create namespace ingress

helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

INGRESS_IP=""
while [ -z $INGRESS_IP ]; do
    INGRESS_IP=$(kubectl get svc nginx-ingress-controller -n ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "Waiting for Ingress service IP... $INGRESS_IP"
    sleep 5
done

kubectl delete svc ratings-web -n ratingsapp

kubectl apply -f ratings-web-service-clusterip.yaml -n ratingsapp

sed -e "s/\$INGRESS_IP/${INGRESS_IP}/" ratings-web-ingress.yaml | kubectl apply -n ratingsapp -f -
# kubectl apply -f ratings-web-ingress.yaml -n ratingsapp

# SSL
kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml

helm install cert-manager \
    --namespace cert-manager \
    --version v0.14.0 \
    jetstack/cert-manager

sed -e "s/\$ISSUER_EMAIL/${ISSUER_EMAIL}/" cluster-issuer.yaml | kubectl apply -n ratingsapp -f -

sed -e "s/\$INGRESS_IP/${INGRESS_IP}/" ratings-web-ingress2.yaml | kubectl apply -n ratingsapp -f -