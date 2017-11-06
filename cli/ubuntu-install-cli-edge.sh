#!/bin/sh
echo "Installs edge version of Azure CLI on Ubuntu / WSL"
echo "Requirements: python3"

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo "Installing pip"
        wget wget https://bootstrap.pypa.io/get-pip.py
        sudo python3 ./get-pip.py
        echo "Installing Azure CLI"
        pip3 install --pre azure-cli --extra-index-url https://azurecliprod.blob.core.windows.net/edge
        rm get-pip*
        echo "Done"
        ;;
    *)
        exit
        ;;
esac

