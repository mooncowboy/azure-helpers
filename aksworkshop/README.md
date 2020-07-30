# AKS Workshop deployment

This folder contains a set of files to fully automate deployment of the official [AKS Workshop](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/). It is strongly recommended that you follow the workshop and only use these files after completing it, as a way to quickly reprovision infrastructure and/or kubernetes resources.

## Usage

To deploy everything, including the AKS cluster, ACR and kubernetes resources:

```
./0-all.sh -g <resource_group> -e <issuer_email>

<resource_group> is the Azure resource group to be created

<issuer_email> is a valid email to be used in Let's Encrypt TLS certificate
```

```
Optionally: 
-c <node_count> (defaults to 3)
-n <node_size> (defaults to Standard_B2ms)
```

To deploy only the kubernetes resources:

```
./2-app.sh

./3-features <issuer_email>
```

## Uninstalling

To delete just the kubernetes resources created by 2-app.sh and 3-features.sh:
```
./uninstall.sh
``` 

To delete everything:

```
az group delete -n <resrouce_group>
```