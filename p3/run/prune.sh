#!/bin/bash

# Importer les fonctions de utils.sh
source ./utils.sh

# Fonction pour supprimer Docker si installé
remove_docker() {
    if command -v docker &>/dev/null; then
        print_message "Docker trouvé. Suppression de Docker..." "yellow"
        
        # Arrêter le service Docker
        sudo systemctl stop docker

        # Désinstaller Docker
        sudo apt-get purge -y docker-ce docker-ce-cli containerd.io
        sudo apt-get autoremove -y

        # Supprimer les images et containers Docker
        sudo rm -rf /var/lib/docker

        print_message "Docker a été supprimé avec succès." "green"
    else
        print_message "Docker n'est pas installé." "yellow"
    fi
}

# Fonction pour supprimer k3d (et k3s si installé)
remove_k3d() {
    if command -v k3d &>/dev/null; then
        print_message "k3d trouvé. Suppression de k3d..." "yellow"
        
        # Supprimer le cluster k3d
        k3d cluster delete mycluster
        
        # Désinstaller k3d
        sudo rm -rf /usr/local/bin/k3d

        print_message "k3d a été supprimé avec succès." "green"
    else
        print_message "k3d n'est pas installé." "yellow"
    fi
}

# Fonction principale pour nettoyer Docker et k3d
prune_system() {
    print_message "Début de la suppression de Docker et k3d..." "blue"
    
    # Supprimer Docker si installé
    remove_docker

    # Supprimer k3d si installé
    remove_k3d

    print_message "Nettoyage terminé." "green"
}

# Lancer la fonction principale
prune_system
