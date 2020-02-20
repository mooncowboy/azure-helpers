#HELM SETUP
wget https://get.helm.sh/helm-v3.1.0-linux-amd64.tar.gz
 
if [ ! -d "./helm" ]; then
 echo 'creating helm directory'
 mkdir helm
fi
 
tar -xvf helm-v3.1.0-linux-amd64.tar.gz -C ./helm
rm helm-v3.1.0-linux-amd64.tar.gz
 
path=$(pwd)
 
echo alias helm="$path/helm/linux-amd64/helm" >> ~/.bash_aliases
exec bash