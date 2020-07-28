set -e

while getopts ":e:g:" opt; do
    case $opt in
        e) EMAIL="$OPTARG"
        ;;
        g) RG="$OPTARG"
        ;;
        c) NODE_COUNT="$OPTARG"
        ;;
        s) NODE_SIZE="$OPTARG"
    esac 
done

usage() {
    echo ""
    echo "Usage: 0-all.sh --g <resource_group> --e <issuer_email>"
    echo ""
    echo "Optional: --c <node_count> --s <node_size>"
}

if [ -z $EMAIL ]; then
    echo "ERROR: Issuer email not specified."
    usage
    exit 1
fi

if [ -z $RG ]; then
    echo "ERROR: Resrouce group not specified."
    usage
    exit 1
fi

echo "Deploying AKS Workshop with values:"
echo "Resource group: $RG"
echo "Node size: $NODE_SIZE"
echo "Node count: $NODE_COUNT"
echo "Issuer email: $EMAIL"

./1-cluster.sh $RG $NODE_COUNT $NODE_SIZE
./2-app.sh
./3-features.sh $EMAIL