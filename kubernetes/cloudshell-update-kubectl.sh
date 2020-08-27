curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl

path=$(pwd)
 
echo alias kubectl="$path/kubectl" >> ~/.bash_aliases
exec bash

kubectl version --client