# Provisions an AKS cluster as described in https://docs.microsoft.com/en-us/learn/modules/aks-workshop/02-deploy-aks
# Added: options to specify RG, node count and node vm size
# Changed: uses managed identity, enables virtual nodes

REGION_NAME=eastus
RESOURCE_GROUP=${1:-aksworkshop}
SUBNET_NAME=aks-subnet
VNET_NAME=aks-vnet
NODE_COUNT=${2:-3}
NODE_VM_SIZE=${3:-Standard_B2ms}
ACR_NAME=acr$RANDOM
AKS_CLUSTER_NAME=aksworkshop-$RANDOM

az group create \
    --name $RESOURCE_GROUP \
    --location $REGION_NAME

az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --location $REGION_NAME \
    --name $VNET_NAME \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.240.0.0/16

SUBNET_ID=$(az network vnet subnet show \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --query id -o tsv)

VERSION=$(az aks get-versions \
    --location $REGION_NAME \
    --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' \
    --output tsv)

az aks create \
--resource-group $RESOURCE_GROUP \
--name $AKS_CLUSTER_NAME \
--vm-set-type VirtualMachineScaleSets \
--load-balancer-sku standard \
--location $REGION_NAME \
--kubernetes-version $VERSION \
--network-plugin azure \
--vnet-subnet-id $SUBNET_ID \
--service-cidr 10.2.0.0/24 \
--dns-service-ip 10.2.0.10 \
--docker-bridge-address 172.17.0.1/16 \
--generate-ssh-keys \
--node-count $NODE_COUNT \
--node-vm-size $NODE_VM_SIZE
--enable-managed-identity

az acr create \
    --resource-group $RESOURCE_GROUP \
    --location $REGION_NAME \
    --name $ACR_NAME \
    --sku Standard

az aks update \
    --name $AKS_CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    --attach-acr $ACR_NAME

WORKSPACE=aksworkshop-workspace-$RANDOM

az resource create --resource-type Microsoft.OperationalInsights/workspaces \
        --name $WORKSPACE \
        --resource-group $RESOURCE_GROUP \
        --location $REGION_NAME \
        --properties '{}' -o table

WORKSPACE_ID=$(az resource show --resource-type Microsoft.OperationalInsights/workspaces \
    --resource-group $RESOURCE_GROUP \
    --name $WORKSPACE \
    --query "id" -o tsv)

az aks enable-addons \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --addons monitoring \
    --workspace-resource-id $WORKSPACE_ID    

az aks enable-addons \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME \
    --addons virtual-node \
    --subnet-name $SUBNET_NAME

az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME

# Store values in .env file so other scripts can use them
ENV_FILE=.env
rm -f $ENV_FILE
echo "RESOURCE_GROUP=$RESOURCE_GROUP" >> $ENV_FILE
echo "AKS_CLUSTER_NAME=$AKS_CLUSTER_NAME" >> $ENV_FILE
echo "ACR_NAME=$ACR_NAME" >> $ENV_FILE