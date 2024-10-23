#!/bin/bash


install_common_packages() {
    echo ">>>>> Installing KUBECTL"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    echo ">>>>> Installing AWS CLI"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    cat <<EOF >>/etc/kubectl_autocomplete.sh
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
EOF

}

install_on_rhel() {
    echo ">>>>> We have found and RHEL system"
            
    echo ">>>>> Installing AZ CLI"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
    sudo dnf -y install azure-cli # Kubelogin installation
    sudo az aks install-cli # Kubelogin installation

    echo ">>>>> Setting up /var/opt for automation"
    sudo mkdir -p /var/opt
    sudo chown -R opsuser:aad_admins /var/opt
    sudo chmod -R 775 /var/opt

    echo ">>>>> Setting up Python3 and utilities for ITA upgrade support"
    sudo dnf install python3-requests -y
    sudo dnf install python3-pip -y
    sudo python3 -m pip install kubernetes
}

install_on_ubuntu() {
    echo ">>>>> We have found and Ubuntu system"

    echo ">>>>> Installing AZ CLI"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    sudo az aks install-cli # Kubelogin installation

    echo ">>>>> Setting up /var/opt for automation"
    sudo mkdir -p /var/opt
    sudo chown -R opsuser:aad_admins /var/opt
    sudo chmod -R 775 /var/opt

    echo ">>>>> Setting up Python3 and utilities for ITA upgrade support"
    sudo apt install python3-requests -y
    sudo apt install python3-pip -y
    sudo python3 -m pip install kubernetes
}

if [ -f /etc/os-release ]; then
    echo "Installing common packages"
    
    install_common_packages
    
    source /etc/os-release
    if [ "$ID" == "rhel" ]; then
            install_on_rhel
    elif [ "$ID" == "ubuntu" ]; then
            install_on_ubuntu
    else
            echo ">>>>> Found Unsupported OS"
            exit 1
    fi
else 
    echo ">>>>> OS cloud not be identified"
        exit 1
fi