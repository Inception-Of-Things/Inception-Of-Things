#!/bin/bash

# Importer les fonctions de utils.sh
source ./utils.sh

# Obtenir le répertoire du script actuel
SCRIPT_DIR=$(dirname "$0")

# Fonction pour charger install.sh et conf.sh lorsque nécessaire
load_install() {
    source "$SCRIPT_DIR/install.sh"
}

load_conf() {
    source "$SCRIPT_DIR/conf.sh"
}

# Fichier main.sh
main() {
    # Vérifier si Docker, kubectl et k3d sont installés
    if ! command -v docker &>/dev/null || ! command -v kubectl &>/dev/null || ! command -v k3d &>/dev/null; then
        # Si l'un des outils n'est pas installé, appeler l'installation
        load_install
        install_all
    else
        print_message "Tous les prérequis (Docker, kubectl, k3d) sont déjà installés." "green"
    fi
    
    # Attente que l'utilisateur appuie sur Entrée avant de continuer
    wait_for_enter "\n =====> Installation des prérequis terminée. <=====\n"

    # Déploiement de k3d
    load_conf
    config_and_deploy

    print_message "\n=====> Cluster k3d créé avec succès, namespaces 'argocd' et 'dev' créés, et l'app est déployé dans 'dev'. <=====\n" "cyan"
}

main