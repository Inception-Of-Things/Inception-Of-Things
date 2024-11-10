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
    load_install   # Charger les fonctions d'installation quand nécessaire
    install_all    # Exécuter l'installation
    
    # Attendre que l'utilisateur appuie sur Entrée avant de continuer
    wait_for_enter "Installation des prérequis terminée. Appuyez sur Entrée pour passer à la suite."
    
    # Charger les fichiers de configuration avant de configurer le cluster
    load_conf      # Charger les configurations
    config_and_deploy

    print_message "Cluster k3d créé avec succès, namespaces 'argocd' et 'dev' créés, et l'app est déployé dans 'dev'." "green"
}

# Appeler la fonction principale
main
