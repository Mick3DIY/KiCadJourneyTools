#!/bin/bash
# -----------------------------------------------------------------------------
# Automated creation of a new KiCad PCB project (FR/EN)
# GitHub project : https://github.com/Mick3DIY/KiCadJourneyTools
# -----------------------------------------------------------------------------
# Usage : ./new_PCB_project.sh <project_name>
# ---------------------------------------------------------
# New project folders overview (by default) :
# 2026-09_<project_name>/
# ├── Code
# ├── FreeCad
# ├── GitHub
# │   ├── assets
# │   ├── code
# │   ├── freecad
# │   ├── kicad
# │   ├── CHANGELOG.md
# │   ├── LICENSE
# │   ├── README.md
# │   ├── .gitignore
# ├── Images
# │   ├── Schematics
# │   └── 3DViews
# ├── KiCad
# │   ├── Datasheets
# │   ├── Libraries
# │   │   ├── 3DModels
# │   │   ├── Footprints
# │   │   └── Symbols
# │   └── aisler-support.zip -> AISLER archive to extract (optional)
# └── TODO.txt
# ---------------------------------------------------------
# Check Bash script (strict mode)
set -euo pipefail
# ---------------------------------------------------------
# Language detection, translations
# ---------------------------------------------------------
# Default is 'en' if not 'fr'
LANG_CODE="${LANG:-en}"
if [[ "$LANG_CODE" =~ ^fr ]]; then
    USER_LANG="fr"
else
	USER_LANG="en"
fi
# Default messages array, feel free to add your own language ^^
declare -A MSG_FR MSG_EN
# French messages
MSG_FR[prompt_name]="Saisir le nom du nouveau projet (le préfixe '%s' sera ajouté) : "
MSG_FR[err_no_name]="Erreur : Aucun nom de projet fourni."
MSG_FR[create_tree]="Création de l'arborescence du projet : %s"
# English messages
MSG_EN[prompt_name]="Enter new project name (prefix '%s' will be added) : "
MSG_EN[err_no_name]="Error: No project name provided."
MSG_EN[create_tree]="Creating main project directory : %s"
# Translation helper
trans() {
    key="$1"
    shift
    if [[ "$USER_LANG" == "fr" ]]; then
        printf "${MSG_FR[$key]}" "$@"
    else
        printf "${MSG_EN[$key]}" "$@"
    fi
}
# ---------------------------------------------------------
# Global constants
# ---------------------------------------------------------
# Main folder, adding date prefix in format: YYYY-MM_ (Example: 2026-09_)
DATE_PREFIX=$(date +%Y-%m_)
# KiCad folder
KICAD_FOLDER="KiCad"
# GitHub folder
GITHUB_FOLDER="GitHub"
# Files to create in GitHub folder
GITHUB_FILES=("CHANGELOG.md" "LICENSE" "README.md" ".gitignore")
# Subdirectories, customize as needed
SUB_DIRS=("Code" "FreeCad" "GitHub" "Images" "${KICAD_FOLDER}")
# Images subdirectories
SUB_DIRS_IMAGES=("Schematics" "3DViews")
# KiCad subdirectories
SUB_DIRS_KICAD=("Datasheets" "Libraries/3DModels" "Libraries/Footprints" "Libraries/Symbols")
# GitHub subdirectories, customize as needed
SUB_DIRS_GITHUB=("assets" "code" "freecad" "kicad")
# Project TODO file
TODO_FILE="TODO.txt"
# AISLER repository for new project settings
AISLER_SUPPORT_ZIP="https://github.com/AislerHQ/aisler-support/archive/refs/heads/master.zip"
# ---------------------------------------------------------
# Global functions
# ---------------------------------------------------------
get_project_name() {
    project_name="${1:-}"
    if [[ -z "$project_name" ]]; then
        read -r -p "$(trans prompt_name "$DATE_PREFIX")" project_name
        if [[ -z "$project_name" ]]; then
            echo "$(trans err_no_name)" >&2; exit 1;
        fi
    fi
    echo "${project_name// /_}"
}
# ---------------------------------------------------------
# Main actions !
# ---------------------------------------------------------
clear

echo $(get_project_name "${1:-}")
