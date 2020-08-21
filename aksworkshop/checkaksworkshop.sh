set -e

CURRDATE=$(date "+%Y%m%d-%H%M%S")
OUTFILE=.output-$CURRDATE.json
NAMESPACE=${1:-ratingsapp}
CLUSTER_NAME=$2
RESOURCE_GROUP=$3

checkConnectionToCluster() {
    echo "Checking connection to cluster..."
    az aks show -n $CLUSTER_NAME -g $RESOURCE_GROUP --query "provisioningState"
}

checkACR() {
    echo "Checking Azure Container Registry..."
}

checkAPI() {
    echo "Checking API deployment and service..."
}

checkFrontend() {
    echo "Checking Frontend deployment and service..."
}

checkIngress() {
    echo "Checking ingress and TLS..."
}

checkMonitoring() {
    echo "Checking monitoring..."
}

checkAutoscaler() {
    echo "Checking autoscaler..."
}

echo "Using namespace $NAMESPACE"
echo "Writing output to $OUTFILE"
echo ""

checkConnectionToCluster
checkACR
checkAPI
checkFrontend
checkIngress
checkMonitoring
checkAutoscaler