#!/bin/bash

# Fonction pour gérer le cluster K3D
manage_cluster() {
    # Vérifie si le cluster existe
    if k3d cluster list | grep -wq "mycluster"; then
        print_message "Le cluster 'mycluster' existe déjà." "yellow"
        # Demande à l'utilisateur s'il veut le recréer
        read -p "Souhaitez-vous supprimer et recréer le cluster 'mycluster' ? (o/n) : " choice
        if [[ "$choice" =~ ^[Oo]$ ]]; then
            k3d cluster delete mycluster
            print_message "Cluster 'mycluster' supprimé avec succès." "green"
            create_k3d_cluster
        else
            print_message "Le cluster 'mycluster' sera conservé." "green"
        fi
    else
        # Si le cluster n'existe pas, on le crée directement
        print_message "Le cluster 'mycluster' n'existe pas. Création en cours..." "blue"
        create_k3d_cluster
    fi
}

# Fonction pour créer un cluster K3D
create_k3d_cluster() {
    print_message "Création du cluster K3D 'mycluster'..." "blue"
    k3d cluster create mycluster --api-port 6443 -p "8888:8888@loadbalancer" --agents 1
    print_message "Cluster 'mycluster' créé avec succès." "green"
}

# Fonction pour gérer les namespaces individuellement
manage_namespaces() {
    local namespaces=("argocd" "dev")
    for ns in "${namespaces[@]}"; do
        if kubectl get namespace $ns -o name &>/dev/null; then
            print_message "Le namespace '$ns' existe déjà." "yellow"
            # Demande à l'utilisateur s'il veut recréer le namespace
            read -p "Souhaitez-vous supprimer et recréer le namespace '$ns' ? (o/n) : " choice
            if [[ "$choice" =~ ^[Oo]$ ]]; then
                kubectl delete namespace $ns
                print_message "Namespace '$ns' supprimé avec succès." "green"
                kubectl create namespace $ns
                print_message "Namespace '$ns' recréé avec succès." "green"
            else
                print_message "Le namespace '$ns' sera conservé." "green"
            fi
        else
            # Si le namespace n'existe pas, on le crée directement
            print_message "Le namespace '$ns' n'existe pas. Création en cours..." "blue"
            kubectl create namespace $ns
            print_message "Namespace '$ns' créé avec succès." "green"
        fi
    done
}

# Fonction pour appliquer un manifest dans un namespace spécifique
apply_manifest() {
    local file_path="$1"
    local namespace="$2"

    if [ ! -f "$file_path" ]; then
        print_message "Erreur : Le fichier '$file_path' est introuvable." "red"
        exit 1
    fi

    print_message "Application du manifest '$file_path' dans le namespace '$namespace'..." "blue"
    kubectl apply -f "$file_path" -n "$namespace"
    print_message "Manifest appliqué avec succès dans le namespace '$namespace'." "green"
}

# Fonction pour déployer l'application dans le namespace 'dev'
deploy_application_in_dev() {
    local file_path="../confs/ns/dev/deployment.yaml"
    apply_manifest "$file_path" "dev"
}

# Fonction pour installer ArgoCD dans le namespace 'argocd'
install_argocd() {
    print_message "Installation d'Argo CD depuis le manifeste officiel..." "blue"
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    print_message "Argo CD installé avec succès dans le namespace 'argocd'." "green"

    local file_path="../confs/ns/argocd/application.yaml"
    apply_manifest "$file_path" "argocd"
}

# Fonction principale pour orchestrer toutes les étapes
config_and_deploy() {
    # Gestion du cluster K3D
    manage_cluster

    # Gestion des namespaces un par un
    manage_namespaces

    # Déploiement de l'application dans 'dev'
    deploy_application_in_dev

    # Installation d'Argo CD dans 'argocd'
    install_argocd
}

