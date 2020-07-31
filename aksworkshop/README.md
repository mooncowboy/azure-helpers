# AKS Workshop validator

Validates successful deployment of the [AKS Workshop](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/). This repo is not official and doesn't replace in any way completion of the contents in [Microsoft Learn](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/) website.

## Requirements

* An Azure subscription
* AKS cluster deployed in that subscription
* kubectl 
* Azure CLI

## Checks

This script checks that the contents of AKS Workshop are successfully deployed in an AKS cluster, specifically:

- Connection to AKS cluster
- Azure Container Registry has the required docker images
- API Deployment and Service correctly exposed
- Frontend Deployment and Service correctly exposed
- Ingress and TLS
- Monitoring enabled
- Autoscaler enabled

**NOTE:** It does not require write access to any resource and only performs read operations.

## Usage

Make sure current context in kubectl is set for the cluster where aksworkshop is deployed and the user has permissions to read resources in that cluster. You can set the current cluster context with:

```
az aks get-credentials -n <cluster_name> -g <resource_group>
```

Once the cluster is set, you can run the tool with:

```
./checkaksworkshop.sh <namespace>

<namspace> is optional and defaults to ratingsapp. Specify this parameter if you deployed AKS Workshop resources in a different namespace.
```

## Disclaimer

## How this works

