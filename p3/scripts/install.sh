#!/bin/bash

# Importer les fonctions de utils.sh
source ./utils.sh

# Fonction pour installer Docker sur Ubuntu
install_docker() {
    print_message "Installation de Docker..." "blue"

    # Vérifier si Docker est déjà installé
    if ! command -v docker &>/dev/null; then
        print_message "Docker n'est pas installé. Installation en cours..." "yellow"

        # Mise à jour des dépôts et installation des dépendances nécessaires
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

        # Ajouter la clé GPG de Docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # Ajouter le dépôt Docker stable
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

        # Mise à jour de la liste des paquets et installation de Docker
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io

        # Démarrer Docker et l'activer pour qu'il se lance au démarrage
        sudo systemctl start docker
        sudo systemctl enable docker

        print_message "Docker installé avec succès." "green"
    else
        print_message "Docker est déjà installé. Restarting Docker..." "green"
        sudo systemctl start docker
    fi
}

# Fonction pour vérifier et ajouter l'utilisateur au groupe docker
add_user_to_docker_group() {
    print_message "Vérification de l'appartenance au groupe 'docker'..." "blue"

    # Vérifier si l'utilisateur fait déjà partie du groupe docker
    if groups $(whoami) | grep &>/dev/null '\bdocker\b'; then
        print_message "L'utilisateur est déjà dans le groupe docker." "green"
    else
        print_message "L'utilisateur n'est pas dans le groupe docker. Ajout en cours..." "yellow"
        sudo usermod -aG docker $(whoami)
        print_message "Utilisateur ajouté au groupe docker. Veuillez vous déconnecter puis vous reconnecter pour appliquer les changements." "yellow"
    fi
}


# Fonction pour vérifier l'installation de kubectl
verify_kubectl() {
    print_message "Vérification de l'installation de kubectl..." "blue"
    if ! command -v kubectl &>/dev/null; then
        print_message "kubectl n'est pas installé. Installation en cours..." "yellow"
        install_kubectl
    else
        print_message "kubectl est déjà installé." "green"
    fi
}

# Fonction pour installer kubectl
install_kubectl() {
    print_message "Installation de kubectl..." "blue"

    # Télécharger et installer la dernière version de kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    print_message "kubectl installé avec succès." "green"
}

# Fonction pour installer k3d
install_k3d() {
    print_message "Installation de k3d..." "blue"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    print_message "k3d installé avec succès." "green"
}

# Fonction pour vérifier l'installation de k3d
verify_k3d() {
    print_message "Vérification de l'installation de k3d..." "blue"
    if ! command -v k3d &>/dev/null; then
        print_message "k3d n'est pas installé. Installation en cours..." "yellow"
        install_k3d
    else
        print_message "k3d est déjà installé." "green"
    fi
}

# Fonction principale pour vérifier et installer Docker, k3d, kubectl, et ajouter l'utilisateur au groupe docker
install_all() {
    install_docker
    verify_kubectl
    verify_k3d
    add_user_to_docker_group
}
