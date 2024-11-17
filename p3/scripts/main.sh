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

# Fonction principale
main() {
    # Installer et vérifier les prérequis
    load_install   
    install_all  
    
    # Attendre que l'utilisateur appuie sur Entrée avant de continuer
    wait_for_enter "\n =====> Installation des prérequis terminée. <=====\n"
    
   
    # Deploiment de k3d
    load_conf      
    config_and_deploy

    print_message "\n=====> Cluster k3d créé avec succès, namespaces 'argocd' et 'dev' créés, et l'app est déployé dans 'dev'. <=====\n" "cyan"
}

# Appeler la fonction principale
main
