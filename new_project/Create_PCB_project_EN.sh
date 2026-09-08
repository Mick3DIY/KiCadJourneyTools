#!/bin/bash
# ----------------------------------------------
# Automated creation of a new KiCad project
# GitHub project: https://github.com/Mick3DIY/KiCadJourneyTools
# ----------------------------------------------
# Command: bash Create_PCB_project_EN.sh <project_name>
# Project folders overview:
# 2026-09_<project_name>/
# ├── Code
# ├── FreeCad
# ├── GitHub
# ├── Images
# │   ├── Schematics
# │   └── 3DViews
# ├── KiCad
# │   ├── Datasheets
# │   ├── Libraries
# │   │   ├── 3DModels
# │   │   ├── Footprints
# │   │   └── Symbols
# │   └── master.zip -> AISLER archive to extract
# └── README.txt
# ----------------------------------------------
# Main folder, adding date prefix in format: YYYY-MM_ (Example: 2026-09_)
DATE_PREFIX=$(date +%Y-%m_)
# KiCad folder
KICAD_FOLDER="KiCad"
# Subdirectories, customize as needed
SUB_DIRS=("Code" "FreeCad" "GitHub" "Images" "${KICAD_FOLDER}")
# Images subdirectories
SUB_DIRS_IMAGES=("Schematics" "3DViews")
# KiCad subdirectories
SUB_DIRS_KICAD=("Datasheets" "Libraries/3DModels" "Libraries/Footprints" "Libraries/Symbols")
# Project documentation file
README_FILE="README.txt"
# AISLER repository for new project settings
AISLER_SUPPORT_ZIP="https://github.com/AislerHQ/aisler-support/archive/refs/heads/master.zip"

clear
# No project name provided as argument
if [[ "$1" == "" ]]; then
	echo "Please enter the project name ('${DATE_PREFIX}' prefix will be added):"
	read -r project_name
	if [ -z "$project_name" ]; then
		echo "Error: No project name entered."
		exit 1
	fi
else
	project_name=$1
fi

# Main project folder
main_dir="${DATE_PREFIX}${project_name}"
echo ""
echo "Creating main directory: $main_dir"

# Using || to handle command failures
mkdir -p "$main_dir" || { echo "Error creating main directory."; exit 1; }

echo ""
echo "Creating subdirectories in $main_dir..."
for dir in "${SUB_DIRS[@]}"; do
    mkdir -p "$main_dir/$dir" || { echo "Error creating subdirectory $dir."; exit 1; }
    echo " - Directory created: $dir"
	# Create Images subdirectories
	if [ "$dir" = "Images" ]; then
		for ssdir in "${SUB_DIRS_IMAGES[@]}"; do
    		mkdir -p "$main_dir/$dir/$ssdir" || { echo "Error creating Images subdirectory $ssdir."; exit 1; }
    		echo "   ⤷ Subdirectory created: $ssdir"
    	done
	fi
    # Create KiCad subdirectories
    if [ "$dir" = "${KICAD_FOLDER}" ]; then
    	for ssdir in "${SUB_DIRS_KICAD[@]}"; do
    		mkdir -p "$main_dir/$dir/$ssdir" || { echo "Error creating KiCad subdirectory $ssdir."; exit 1; }
    		echo "   ⤷ Subdirectory created: $ssdir"
    	done
	fi
done

# Project documentation file, customize as needed
readme_file="$main_dir/${README_FILE}"
echo ""
echo "Creating and writing to file $readme_file"
echo "Project description" > "$readme_file" || { echo "Error creating or writing to ${README_FILE}."; exit 1; }
echo ""

# AISLER Support to KiCad folder, customize as needed
echo "Downloading AISLER archive..."
echo ""
wget -q ${AISLER_SUPPORT_ZIP} -P "$main_dir/${KICAD_FOLDER}" || { echo "Error downloading AISLER archive."; exit 1; }
echo "AISLER archive created in directory $main_dir/${KICAD_FOLDER}"
echo ""
