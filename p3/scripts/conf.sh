#!/bin/bash

# Fonction pour vérifier si le cluster k3d existe
check_cluster_exists() {
    # Vérification de l'existence du cluster 'mycluster'
    if k3d cluster list | grep -wq "mycluster"; then
        print_message "Le cluster 'mycluster' existe déjà." "yellow"
        return 0  # Le cluster existe
    else
        print_message "Le cluster 'mycluster' n'existe pas." "yellow"
        return 1  # Le cluster n'existe pas
    fi
}

# Fonction pour créer un cluster k3d
create_k3d_cluster() {
    print_message "\n🚀 Création du cluster k3d..." "blue"
    k3d cluster create mycluster --api-port 6443 -p "8888:8888@loadbalancer" --agents 1
}

# Fonction pour vérifier l'existence des namespaces et proposer de les recréer
check_and_recreate_namespaces() {
    # Vérification de l'existence des namespaces 'argocd' et 'dev'
    if kubectl get namespace argocd -o name &>/dev/null; then
        print_message "Le namespace 'argocd' existe déjà." "yellow"
        read -p "Souhaitez-vous le supprimer et le recréer ? (o/n) : " choice
        if [[ "$choice" == "o" || "$choice" == "O" ]]; then
            kubectl delete namespace argocd
            print_message "Namespace 'argocd' supprimé. Création d'un nouveau namespace." "green"
            kubectl create namespace argocd
            print_message "Namespace 'argocd' créé avec succès." "green"
        else
            print_message "Passage au prochain namespace sans modification." "green"
        fi
    else
        print_message "Le namespace 'argocd' n'existe pas." "yellow"
        kubectl create namespace argocd
        print_message "Namespace 'argocd' créé avec succès." "green"
    fi

    if kubectl get namespace dev -o name &>/dev/null; then
        print_message "Le namespace 'dev' existe déjà." "yellow"
        read -p "Souhaitez-vous le supprimer et le recréer ? (o/n) : " choice
        if [[ "$choice" == "o" || "$choice" == "O" ]]; then
            kubectl delete namespace dev
            print_message "Namespace 'dev' supprimé. Création d'un nouveau namespace." "green"
            kubectl create namespace dev
            print_message "Namespace 'dev' créé avec succès." "green"
        else
            print_message "Passage au prochain namespace sans modification." "green"
        fi
    else
        print_message "Le namespace 'dev' n'existe pas." "yellow"
        kubectl create namespace dev
        print_message "Namespace 'dev' créé avec succès." "green"
    fi
}



# Fonction pour appliquer le manifest deployment.yaml pour l'application dans le namespace 'dev'
apply_dev_deployment() {

    # Chemin du manifest deployment.yaml pour dev
    FILE_PATH="../confs/ns/dev/deployment.yaml"
    
    print_message "Integration du manifest $FILE_PATH dans le namespace 'dev'..." "blue"
    

    # Vérifier si le manifest deployment.yaml existe
    if [ ! -f $FILE_PATH ]; then
        print_message "Le manifest $FILE_PATH n'a pas été trouvé." "red"
        exit 1
    fi
    
    # Appliquer le manifest deployment.yaml
    kubectl apply -f $FILE_PATH
    print_message "Déploiement de l'app effectué avec succès dans le namespace 'dev'." "green"
}

# Fonction pour installer Argo CD et configurer l'application
apply_argocd_install() {
    print_message "Installation d'Argo CD depuis le manifeste officiel..." "blue"
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    print_message "Argo CD installé avec succès dans le namespace 'argocd'." "green"

    FILE_PATH="../confs/ns/argocd/application.yaml"

    # Vérifier si le manifest application.yaml existe
    if [ ! -f $FILE_PATH ]; then
        print_message "Le manifest $FILE_PATH n'a pas été trouvé." "red"
        exit 1
    fi

    # Appliquer le manifest application.yaml
    kubectl apply -f $FILE_PATH
    print_message "Integration du manifest $FILE_PATH dans le namespace 'app'..." "blue"

}

# Fonction principale pour configurer le cluster k3d, créer les namespaces, et appliquer le déploiement
config_and_deploy() {
    # Vérification du cluster avant de le créer
    if ! check_cluster_exists; then
        create_k3d_cluster
    fi

    # Vérification et création des namespaces si nécessaireq
    check_and_recreate_namespaces

    # Appliquer le déploiement de l'application dans le namespace 'dev'
    apply_dev_deployment

    # Installation Argo CD dans le namespace 'argocd'
    apply_argocd_install
}

# Lancer la fonction principale
config_and_deploy
