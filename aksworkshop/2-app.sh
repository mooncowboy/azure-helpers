RESOURCE_GROUP=$1
ACR_NAME=$2

kubectl create namespace ratingsapp

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

az acr repository list \
    --name $ACR_NAME \
    --output table

helm repo add bitnami https://charts.bitnami.com/bitnami

$MONGO_USER=ratingsuser
$MONGO_PASS=ratingspass

helm install ratings bitnami/mongodb \ 
    --namespace ratingsapp \ 
    --set auth.username=$ratingsuser,auth.password=$ratingspass,auth.database=ratingsdb

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

kubectl get service ratings-web --namespace ratingsapp -w