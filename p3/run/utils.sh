#!/bin/bash

# Fonction pour afficher les messages avec couleur
print_message() {
    local MESSAGE=$1
    local COLOR=$2

    # Définir les couleurs (codes ANSI)
    case $COLOR in
        "red")    local COLOR_CODE='\033[0;31m' ;;   # Rouge
        "green")  local COLOR_CODE='\033[0;32m' ;;   # Vert
        "yellow") local COLOR_CODE='\033[0;33m' ;;   # Jaune
        "blue")   local COLOR_CODE='\033[0;34m' ;;   # Bleu
        "purple") local COLOR_CODE='\033[0;35m' ;;   # Violet
        "cyan")   local COLOR_CODE='\033[0;36m' ;;   # Cyan
        "white")  local COLOR_CODE='\033[0;37m' ;;   # Blanc
        "reset")  local COLOR_CODE='\033[0m' ;;      # Reset (couleur par défaut)
        *)        local COLOR_CODE='\033[0m' ;;      # Par défaut
    esac

    # Afficher le message avec la couleur
    echo -e "${COLOR_CODE}${MESSAGE}\033[0m"
}