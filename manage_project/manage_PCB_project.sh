#!/bin/bash
# -----------------------------------------------------------------------------
# Automated managment, tests for a KiCad PCB project (FR/EN)
# GitHub project : https://github.com/Mick3DIY/KiCadJourneyTools
# -----------------------------------------------------------------------------
# Usage :
# - with your default language : ./manage_PCB_project.sh <project_name_with_URI>
# - with a particular language : LANG=en ./manage_PCB_project.sh <project_name_with_URI>
# ---------------------------------------------------------
# KiCad general workflow : Schematic ⟶ Printed Circuit Board (PCB) ⟶ Exports for fabrication
# Schematic workflow : Electrical Rule Check (ERC) ⟶ export Bill Of Materials (BOM), print schematic in PDF
# PCB workflow : TODO
# Exports workflow : TODO
# KiCad Command Line Interface (CLI) : https://docs.kicad.org/master/en/cli/cli.html
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
MSG_FR[usage]="./manage_PCB_project.sh <nom_projet_avec_URI>"
MSG_FR[err_no_name]="Erreur : Aucun nom de projet fourni ! Usage :"
MSG_FR[created_dir]="Dossier créé : %s"
MSG_FR[erc_pass]="Aucune erreur pour les tests ERC"
MSG_FR[erc_failed]="Erreur : les tests ERC ont échoué !"
MSG_FR[bom_pass]="Fichier BOM créé avec succès"
MSG_FR[bom_failed]="Erreur : Lors de la création du fichier export BOM !"
MSG_FR[pdf_pass]="Fichier PDF créé avec succès"
MSG_FR[pdf_failed]="Erreur : Lors de la création du fichier PDF !"
# English messages
MSG_EN[usage]="./manage_PCB_project.sh <project_name_with_URI>"
MSG_EN[err_no_name]="Error : No project name provided ! Usage :"
MSG_EN[created_dir]="Directory created : %s"
MSG_EN[erc_pass]="No error during ERC tests"
MSG_EN[erc_failed]="Error : ERC tests has failed !"
MSG_EN[bom_pass]="BOM file created successfully"
MSG_EN[bom_failed]="Error : During created BOM file export !"
MSG_EN[pdf_pass]="PDF file created successfully"
MSG_EN[pdf_failed]="Error : During created PDF file !"
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
# Export folder, adding date prefix in format: YYYY-mm-dd_s (Example: 2026-09-28_UnixTimeStamp_Export)
DATE_PREFIX=$(date +%Y-%m-%d_%s)
EXPORT_FOLDER="${DATE_PREFIX}_Export"
# KiCad CLI schematic commands :
CLI_SCH_ERC_REPORT="erc-report.rpt"
CLI_SCH_ERC_REPORT_URI="${EXPORT_FOLDER}/${CLI_SCH_ERC_REPORT}"
CLI_SCH_ERC="kicad-cli sch erc --severity-error --output ${CLI_SCH_ERC_REPORT_URI} --exit-code-violations"
CLI_SCH_BOM_FILE="bom.csv"
CLI_SCH_BOM_FILE_URI="${EXPORT_FOLDER}/${CLI_SCH_BOM_FILE}"
CLI_SCH_BOM="kicad-cli sch export bom --exclude-dnp --group-by "Value,Footprint" --output ${CLI_SCH_BOM_FILE_URI}"
CLI_SCH_PDF_FILE="schematic.pdf"
CLI_SCH_PDF_FILE_URI="${EXPORT_FOLDER}/${CLI_SCH_PDF_FILE}"
CLI_SCH_PDF="kicad-cli sch export pdf --output ${CLI_SCH_PDF_FILE_URI}"
# ---------------------------------------------------------
# Global functions
# ---------------------------------------------------------
get_project_name() {
    local project_name="${1:-}"
    if [[ -z "$project_name" ]]; then
        echo "$(trans err_no_name) $(trans usage)" >&2; exit 1;
    fi
    echo "${project_name// /_}" # Return value
}

check_schematic_erc() {
    local cli_sch_erc="$1"
    if $cli_sch_erc; then
        echo "$(trans erc_pass)"
    else
        echo "$(trans erc_failed)"
        cat "${CLI_SCH_ERC_REPORT_URI}"
        exit 1
    fi
}

export_schematic_bom() {
    local cli_sch_bom="$1"
    if $cli_sch_bom; then
        echo "$(trans bom_pass)"
    else
        echo "$(trans bom_failed)"
        exit 1
    fi
}

export_schematic_pdf() {
    local cli_sch_pdf="$1"
    if $cli_sch_pdf; then
        echo "$(trans pdf_pass)"
    else
        echo "$(trans pdf_failed)"
        exit 1
    fi
}
# ---------------------------------------------------------
# Main actions, customize as needed !
# ---------------------------------------------------------
clear
project_name="$(get_project_name "${1:-}")"
if [[ -n "$project_name" ]]; then
    # Main report folder
    main_dir=${EXPORT_FOLDER}
    mkdir -p "$main_dir"
    echo "$(trans created_dir "$main_dir")"
    # Project name (schematic)
    project_file="${project_name}.kicad_sch"
    # Check the ERC on the schematic
    check_schematic_erc "${CLI_SCH_ERC} ${project_file}"
    # Export the BOM to a CSV file
    export_schematic_bom "${CLI_SCH_BOM} ${project_file}"
    # Export the schematic to a PDF file
    export_schematic_pdf "${CLI_SCH_PDF} ${project_file}"
fi
