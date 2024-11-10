#!/bin/bash

# Obtenir le répertoire du script actuel
SCRIPT_DIR=$(dirname "$0")

# Source des fichiers de configuration avec le chemin absolu
source "$SCRIPT_DIR/install.sh"
source "$SCRIPT_DIR/conf.sh"


# Fonction principale
main() {
    # Installer et vérifier les prérequis
    install_all
    
    # Configurer le cluster, namespaces et déployer l'application
    config_and_deploy

    print_message "Cluster k3d créé avec succès, namespaces 'argocd' et 'dev' créés, et l'app est déployé dans 'dev'." "green"
}

# Appeler la fonction principale
main
