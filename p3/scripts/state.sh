#!/bin/bash

# Importer la fonction print_message de utils.sh
source ./utils.sh

# Vérification des arguments
if [ $# -ne 2 ] && [ $# -ne 1 ]; then
    print_message "Usage: bash $0 [ressource] [namespace]" "red"
    print_message "Exemple: bash $0 pods dev" "yellow"
    print_message "Ou pour tout vérifier : bash $0 all dev" "yellow"
    exit 1
fi

# Assignation des arguments à des variables
RESOURCE=$1
NAMESPACE=$2

# Vérifier si le namespace existe
namespace_exists=$(kubectl get namespace $NAMESPACE --ignore-not-found)
if [ -z "$namespace_exists" ]; then
    print_message "Le namespace '$NAMESPACE' n'existe pas." "red"
    exit 1
fi

# Fonction pour afficher l'état des pods
check_pods() {
    print_message "Vérification des pods dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get pods -n $NAMESPACE
}

# Fonction pour afficher l'état des services
check_services() {
    print_message "Vérification des services dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get services -n $NAMESPACE
}

# Fonction pour afficher l'état des déploiements
check_deployments() {
    print_message "Vérification des déploiements dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get deployments -n $NAMESPACE
}

# Fonction pour afficher l'état des replicasets
check_replicasets() {
    print_message "Vérification des ReplicaSets dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get replicasets -n $NAMESPACE
}

# Fonction pour afficher l'état des configurations
check_configmaps() {
    print_message "Vérification des ConfigMaps dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get configmaps -n $NAMESPACE
}

# Fonction pour afficher l'état des secrets
check_secrets() {
    print_message "Vérification des Secrets dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get secrets -n $NAMESPACE
}

# Fonction pour afficher les logs d'un pod
check_logs() {
    # Récupérer le nom du premier pod dans le namespace
    POD_NAME=$(kubectl get pods -n $NAMESPACE -o custom-columns=":metadata.name" --no-headers | head -n 1)
    
    # Vérifier si un pod a été trouvé
    if [ -z "$POD_NAME" ]; then
        print_message "Aucun pod trouvé dans le namespace '$NAMESPACE'." "red"
        return 1  # Retourner un code d'erreur
    fi

    print_message "Vérification des logs du pod '$POD_NAME' dans le namespace '$NAMESPACE'..." "yellow"
    
    # Récupérer les logs du pod
    kubectl logs $POD_NAME -n $NAMESPACE
}

# Fonction pour afficher les événements du namespace
check_events() {
    print_message "Vérification des événements dans le namespace '$NAMESPACE'..." "yellow"
    kubectl get events -n $NAMESPACE --sort-by='.metadata.creationTimestamp'
}

# Fonction pour afficher l'état des nodes
check_nodes() {
    print_message "Vérification des nodes du cluster..." "yellow"
    kubectl get nodes
}

# Fonction pour afficher les ressources
check_resources() {
    print_message "Vérification des ressources du namespace '$NAMESPACE'..." "yellow"
    kubectl top pod -n $NAMESPACE
}

# Fonction pour tout vérifier (appeler toutes les autres fonctions)
check_all() {
    print_message "Vérification complète de toutes les ressources dans le namespace '$NAMESPACE'..." "green"

    # Appeler toutes les fonctions de vérification
    check_pods
    check_services
    check_deployments
    check_replicasets
    check_configmaps
    check_secrets
    check_logs
    check_events
    check_nodes
    check_resources
}

# Vérification du type de ressource demandé
case $RESOURCE in
    "pods")
        check_pods
        ;;
    "services")
        check_services
        ;;
    "deployments")
        check_deployments
        ;;
    "replicasets")
        check_replicasets
        ;;
    "configmaps")
        check_configmaps
        ;;
    "secrets")
        check_secrets
        ;;
    "logs")
        check_logs
        ;;
    "events")
        check_events
        ;;
    "nodes")
        check_nodes
        ;;
    "resources")
        check_resources
        ;;
    "all")
        check_all
        ;;
    *)
        print_message "Ressource inconnue: $RESOURCE" "red"
        print_message "Les ressources valides sont : pods, services, deployments, replicasets, configmaps, secrets, logs, events, nodes, resources, all" "yellow"
        exit 1
        ;;
esac
