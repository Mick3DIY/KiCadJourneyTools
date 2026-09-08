#!/bin/bash
# ----------------------------------------------
# Création automatisé d'un nouveau projet KiCad
# Projet GitHub : https://github.com/Mick3DIY/KiCadJourneyTools
# ----------------------------------------------
# Commande : bash Creer_projet_PCB_FR.sh <nom_du_projet>
# Aperçu des dossiers du projet :
# 2026-09_<nom_du_projet>/
# ├── Code
# ├── FreeCad
# ├── GitHub
# ├── Images
# │   ├── Schémas
# │   └── Vues3D
# ├── KiCad
# │   ├── Datasheets
# │   ├── Libraries
# │   │   ├── 3DModels
# │   │   ├── Footprints
# │   │   └── Symbols
# │   └── master.zip -> Archive AISLER à décompresser
# └── Lisezmoi.txt
# ----------------------------------------------
# Dossier principal, ajout de la date au format : AAAA-MM_ (Exemple : 2026-09_)
DATE_PREFIX=$(date +%Y-%m_)
# Dossier KiCad
KICAD_FOLDER="KiCad"
# Sous-dossiers, à modifier selon vos besoins
SUB_DIRS=("Code" "FreeCad" "GitHub" "Images" "${KICAD_FOLDER}")
# Sous-dossiers Images
SUB_DIRS_IMAGES=("Schémas" "Vues3D")
# Sous-dossiers KiCad
SUB_DIRS_KICAD=("Datasheets" "Libraries/3DModels" "Libraries/Footprints" "Libraries/Symbols")
# Fichier documentation du projet
README_FILE="Lisezmoi.txt"
# Dépôt de AISLER pour les paramètres du nouveau projet
AISLER_SUPPORT_ZIP="https://github.com/AislerHQ/aisler-support/archive/refs/heads/master.zip"

clear
# Aucun nom de projet en argument
if [[ "$1" == "" ]]; then
	echo "Veuillez saisir le nom du projet (le préfixe '${DATE_PREFIX}' sera ajouté) :"
	read -r project_name
	if [ -z "$project_name" ]; then
		echo "Erreur : Aucun nom de projet saisi."
		exit 1
	fi
else
	project_name=$1
fi

# Dossier principal du projet
main_dir="${DATE_PREFIX}${project_name}"
echo ""
echo "Création du dossier principal : $main_dir"

# Utilisation de || pour gérer les échecs de commande
mkdir -p "$main_dir" || { echo "Erreur lors de la création du dossier principal."; exit 1; }

echo ""
echo "Création des sous-dossiers dans $main_dir..."
for dir in "${SUB_DIRS[@]}"; do
    mkdir -p "$main_dir/$dir" || { echo "Erreur lors de la création du sous-dossier $dir."; exit 1; }
    echo " - Dossier créé : $dir"
	# Création des sous-dossiers pour Images
	if [ "$dir" = "Images" ]; then
		for ssdir in "${SUB_DIRS_IMAGES[@]}"; do
    		mkdir -p "$main_dir/$dir/$ssdir" || { echo "Erreur lors de la création du sous-dossier Images $ssdir."; exit 1; }
    		echo "   ⤷ Sous-dossier créé : $ssdir"
    	done
	fi
    # Création des sous-dossiers pour KiCad
    if [ "$dir" = "${KICAD_FOLDER}" ]; then
    	for ssdir in "${SUB_DIRS_KICAD[@]}"; do
    		mkdir -p "$main_dir/$dir/$ssdir" || { echo "Erreur lors de la création du sous-dossier KiCad $ssdir."; exit 1; }
    		echo "   ⤷ Sous-dossier créé : $ssdir"
    	done
	fi
done

# Fichier documentation du projet, à modifier selon vos besoins
readme_file="$main_dir/${README_FILE}"
echo ""
echo "Création et écriture dans le fichier $readme_file"
echo "Description du projet" > "$readme_file" || { echo "Erreur lors de la création ou de l'écriture dans ${README_FILE}."; exit 1; }
echo ""

# AISLER Support vers le dossier KiCad, à modifier selon vos besoins
echo "Téléchargement de l'archive AISLER..."
echo ""
wget -q ${AISLER_SUPPORT_ZIP} -P "$main_dir/${KICAD_FOLDER}" || { echo "Erreur lors du téléchargement de l'archive AISLER."; exit 1; }
echo "Archive AISLER créée dans le dossier $main_dir/${KICAD_FOLDER}"
echo ""
