# install azure cli on wsl
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install docker on ununtu 22.04
# https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# install docker compose
# https://docs.docker.com/compose/install/
sudo apt install -y docker-compose

# install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

exit

# Run as normal user 

# install nvm on ubuntu 22.04
sudo apt install -y curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
source ~/.profile

# install latest node using nvm
nvm install node

#install brew in ubuntu 22.04
# https://docs.brew.sh/Homebrew-on-Linux
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install helm
# https://helm.sh/docs/intro/install/
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# install kubectx on ubuntu 22.04
brew install kubectx

#install kubens on ubuntu 22.04
brew install kubens
