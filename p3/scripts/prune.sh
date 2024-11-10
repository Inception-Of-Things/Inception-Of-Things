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

# Fonction pour demander à l'utilisateur s'il veut supprimer un package
prompt_removal() {
    local package=$1
    local action=$2

    while true; do
        print_message "Voulez-vous supprimer $package ? (y/n)" "blue"
        read -r response
        case "$response" in
            [Yy]*)
                $action
                return 0
                ;;
            [Nn]*)
                print_message "$package n'a pas été supprimé." "green"
                return 0
                ;;
            *)
                print_message "Réponse invalide. Veuillez répondre par 'y' ou 'n'." "red"
                ;;
        esac
    done
}

# Fonction principale pour nettoyer Docker et k3d
prune_system() {
    print_message "Début de la suppression de Docker et k3d..." "blue"

    # Si l'option --all est donnée, supprimer tout sans demander
    if [[ "$1" == "--all" ]]; then
        print_message "Suppression de Docker et k3d sans confirmation..." "yellow"
        remove_k3d
        remove_docker
        print_message "Nettoyage terminé." "green"
        return
    fi

    # Si aucune option n'est donnée, demander confirmation pour Docker et k3d
    if command -v k3d &>/dev/null; then
        prompt_removal "k3d" remove_k3d
    fi
    
    if command -v docker &>/dev/null; then
        prompt_removal "Docker" remove_docker
    fi

    print_message "Nettoyage terminé." "green"
}

# Lancer la fonction principale
prune_system "$1"
