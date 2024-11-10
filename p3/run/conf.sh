#!/bin/bash

# Importer les fonctions de utils.sh
source ./utils.sh

# Fonction pour vérifier si le cluster k3d existe
check_cluster_exists() {
    # Vérification de l'existence du cluster 'mycluster'
    cluster_exists=$(k3d cluster list | grep -w "mycluster")

    if [ -z "$cluster_exists" ]; then
        print_message "Le cluster 'mycluster' n'existe pas." "yellow"
        return 1  # Le cluster n'existe pas
    else
        print_message "Le cluster 'mycluster' existe déjà." "yellow"
        return 0  # Le cluster existe
    fi
}

# Fonction pour vérifier l'existence des namespaces et proposer de les recréer
check_and_recreate_namespaces() {
    # Vérification de l'existence des namespaces 'argocd' et 'dev'
    argocd_exists=$(kubectl get namespace argocd --ignore-not-found)
    dev_exists=$(kubectl get namespace dev --ignore-not-found)

    # Vérification de l'existence du namespace 'argocd'
    if [ -n "$argocd_exists" ]; then
        print_message "Le namespace 'argocd' existe déjà." "yellow"
        read -p "Souhaitez-vous le supprimer et le recréer ? (o/n) : " choice
        if [[ "$choice" == "o" || "$choice" == "O" ]]; then
            kubectl delete namespace argocd
            print_message "Namespace 'argocd' supprimé. Création d'un nouveau namespace." "green"
            kubectl create namespace argocd
        else
            print_message "Passage au prochain namespace sans modification." "green"
        fi
    else
        print_message "Le namespace 'argocd' n'existe pas." "yellow"
        kubectl create namespace argocd
        print_message "Namespace 'argocd' créé avec succès." "green"
    fi

    # Vérification de l'existence du namespace 'dev'
    if [ -n "$dev_exists" ]; then
        print_message "Le namespace 'dev' existe déjà." "yellow"
        read -p "Souhaitez-vous le supprimer et le recréer ? (o/n) : " choice
        if [[ "$choice" == "o" || "$choice" == "O" ]]; then
            kubectl delete namespace dev
            print_message "Namespace 'dev' supprimé. Création d'un nouveau namespace." "green"
            kubectl create namespace dev
        else
            print_message "Passage au prochain namespace sans modification." "green"
        fi
    else
        print_message "Le namespace 'dev' n'existe pas." "yellow"
        kubectl create namespace dev
        print_message "Namespace 'dev' créé avec succès." "green"
    fi
}

# Fonction pour créer un cluster k3d
create_k3d_cluster() {
    print_message "Création du cluster k3d..." "blue"
    k3d cluster create mycluster --api-port 6443 -p "8888:8888@loadbalancer" --agents 1
}

# Fonction pour créer les namespaces 'argocd' et 'dev'
create_namespaces() {
    print_message "Création des namespaces 'argocd' et 'dev'..." "blue"
    kubectl create namespace argocd
    kubectl create namespace dev
}

# Fonction pour appliquer le fichier deployment.yml pour l'app
apply_deployment() {
    print_message "Application du fichier ../confs/deployment.yml dans le namespace 'dev'..." "blue"
    
    # Vérifier si le fichier deployment.yml existe
    if [ ! -f "../confs/deployment.yml" ]; then
        print_message "Le fichier ../confs/deployment.yml n'a pas été trouvé dans le répertoire courant." "red"
        exit 1
    fi
    
    # Appliquer le fichier deployment.yml
    kubectl apply -n dev -f ../confs/deployment.yml
    print_message "Déploiement de l'app effectué avec succès dans le namespace 'dev'." "green"
}

# Fonction principale pour configurer le cluster k3d, créer les namespaces, et appliquer le déploiement
config_and_deploy() {
    # Vérification du cluster avant de le créer
    check_cluster_exists
    if [ $? -eq 1 ]; then
        create_k3d_cluster
    fi

    # Vérification et création des namespaces si nécessaire
    check_and_recreate_namespaces

    # Appliquer le déploiement
    apply_deployment
}

# Lancer la fonction principale
config_and_deploy
