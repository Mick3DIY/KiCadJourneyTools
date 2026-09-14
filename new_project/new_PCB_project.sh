#!/bin/bash
# -----------------------------------------------------------------------------
# Automated creation of a new KiCad PCB project (FR/EN)
# GitHub project : https://github.com/Mick3DIY/KiCadJourneyTools
# -----------------------------------------------------------------------------
# Usage :
# - with your default language : ./new_PCB_project.sh <project_name>
# - with a particular language : LANG=en ./new_PCB_project.sh <project_name>
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
# Default language is 'en' if not 'fr'
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
MSG_FR[created_dir]="Dossier créé : %s"
MSG_FR[created_sdir]=" ⤷ Sous-dossier créé : %s"
MSG_FR[created_file]=" ⤷ Fichier créé : %s"
MSG_FR[download_file]="Téléchargement du fichier %s"
MSG_FR[download_error]="Erreur : Lors du téléchargement du fichier %s via curl/wget."
# English messages
MSG_EN[prompt_name]="Enter new project name (prefix '%s' will be added) : "
MSG_EN[err_no_name]="Error : No project name provided."
MSG_EN[create_tree]="Creating main project directory : %s"
MSG_EN[created_dir]="Directory created : %s"
MSG_EN[created_sdir]=" ⤷ Subdirectory created : %s"
MSG_EN[created_file]=" ⤷ File created : %s"
MSG_EN[download_file]="Download the file %s"
MSG_EN[download_error]="Error : When downloading the file %s with curl/wget."
# Translation helper
trans() {
    key="$1" # Message parameter
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
# AISLER repository for new project settings (optional)
AISLER_SUPPORT_URL="https://github.com/AislerHQ/aisler-support/archive/refs/heads/master.zip"
AISLER_SUPPORT_ZIP="aisler-support.zip"
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
    echo "${project_name// /_}" # Return value
}

create_subdirectories() {
    project_dir="$1"
    # Main project folder
    echo "$(trans create_tree "$project_dir")"
    mkdir -p "$project_dir"
    # Main loop for subdirectories
    for dir in "${SUB_DIRS[@]}"; do
        mkdir -p "$project_dir/$dir"
        echo "$(trans created_dir "$dir")"
        # Create Images subdirectories
        if [ "$dir" = "Images" ]; then
            for ssdir in "${SUB_DIRS_IMAGES[@]}"; do
                mkdir -p "$project_dir/$dir/$ssdir"
                echo "$(trans created_sdir "$ssdir")"
            done
        fi
        # Create KiCad subdirectories
        if [ "$dir" = "${KICAD_FOLDER}" ]; then
            for ssdir in "${SUB_DIRS_KICAD[@]}"; do
                mkdir -p "$main_dir/$dir/$ssdir"
                echo "$(trans created_sdir "$ssdir")"
            done
	    fi
        # Create GitHub subdirectories
	    if [ "$dir" = "${GITHUB_FOLDER}" ]; then
            # Folders to create
            for ssdir in "${SUB_DIRS_GITHUB[@]}"; do
                mkdir -p "$main_dir/$dir/$ssdir"
                echo "$(trans created_sdir "$ssdir")"
            done
            # Files to create
            for ssfiles in "${GITHUB_FILES[@]}"; do
                touch $main_dir/$dir/$ssfiles
                echo "$(trans created_file "$ssfiles")"
            done
	    fi
    done
}

create_file() {
    project_dir="$1"
    file="$2"
    # File to create
    touch "${project_dir}/${file}"
    message="$(trans created_file "${file}")"
    echo ${message:3} # Cut the firt 3 characters ;)
}

download_archive() {
    project_dir="$1"
    archive_url="$2"
    archive_name="$3"
    archive_folder="$project_dir/${KICAD_FOLDER}"
	echo "$(trans download_file "$archive_url")"
	# Downloading from curl ou wget ?
	if command -v curl &> /dev/null; then
    	curl -sL "${archive_url}" -o "${archive_folder}/${archive_name}"
	elif command -v wget &> /dev/null; then
    	wget -q "${archive_url}" -O "${archive_folder}/${archive_name}"
	else
    	echo "$(trans download_error "$archive_url")"
	fi
}
# ---------------------------------------------------------
# Main actions, customize as needed !
# ---------------------------------------------------------
clear
# Main directories for the project
main_dir="${DATE_PREFIX}$(get_project_name "${1:-}")"
create_subdirectories "${main_dir}"
# TODO file for the project
create_file "${main_dir}" "${TODO_FILE}"
# AISLER archive (optional)
download_archive "${main_dir}" "${AISLER_SUPPORT_URL}" "${AISLER_SUPPORT_ZIP}"
