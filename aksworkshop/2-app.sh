# Make sure .env file exists before running this 
source .env

# set to true to enable MongoDB persistent storage
PERSISTENCE=false
SKIP_BUILD=${1:-false}

kubectl create namespace ratingsapp

if [ "$SKIP_BUILD" = false ]; then
    az acr build \
        --resource-group $RESOURCE_GROUP \
        --registry $ACR_NAME \
        --image ratings-api:v1 \
        https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-api.git

    az acr build \
        --resource-group $RESOURCE_GROUP \
        --registry $ACR_NAME \
        --image ratings-web:v1 \
        https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-web.git
fi

az acr repository list \
    --name $ACR_NAME \
    --output table

helm repo add bitnami https://charts.bitnami.com/bitnami

MONGO_USER="ratingsuser"
MONGO_PASS="ratingspass"

helm install ratings bitnami/mongodb \
    --namespace ratingsapp \
    --set auth.username=$MONGO_USER,auth.password=$MONGO_PASS,auth.database=ratingsdb,persistence.enabled=$PERSISTENCE

kubectl create secret generic mongosecret \
    --namespace ratingsapp \
    --from-literal=MONGOCONNECTION="mongodb://$MONGO_USER:$MONGO_PASS@ratings-mongodb.ratingsapp:27017/ratingsdb"

kubectl describe secret mongosecret --namespace ratingsapp

kubectl apply \
    --namespace ratingsapp \
    -f ratings-api-deployment.yaml

kubectl apply \
    --namespace ratingsapp \
    -f ratings-api-service.yaml

kubectl apply \
    --namespace ratingsapp \
    -f ratings-web-deployment.yaml

kubectl apply \
    --namespace ratingsapp \
    -f ratings-web-service.yaml

kubectl set image deploy/ratings-api -n ratingsapp ratings-api=$ACR_NAME.azurecr.io/ratings-api:v1
kubectl set image deploy/ratings-web -n ratingsapp ratings-web=$ACR_NAME.azurecr.io/ratings-web:v1

# kubectl get service ratings-web --namespace ratingsapp -w

# RATINGS_WEB_IP=""
# while [ -z $RATINGS_WEB_IP ]; do
#     RATINGS_WEB_IP=$(kubectl get svc ratings-web -n ratingsapp -o jsonpath='.status.loadBalancer.ingress[0].ip')
#     echo "Waiting for external ip... $RATINGS_WEB_IP"
#     sleep 5
# done

# echo "Ratings web service available at: $EXTERNAL_IP"