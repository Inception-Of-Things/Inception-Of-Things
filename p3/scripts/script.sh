# Installation Docker
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common docker.io

# setting Kubernetes
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
echo $PASSWORD | sudo mv ./kubectl /usr/local/bin/kubectl

# Instalation K3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash



# Create ArgoCD namespace
# kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml