#!/bin/bash
################################################################################
# init.sh — Initialisation et validation
# Contient : init_repository(), validate_target_dir()
################################################################################

# ============================================================================
# FONCTION : init_repository()
# Crée la structure du dépôt ~/.snapfile/ si elle n'existe pas encore
# ============================================================================
init_repository() {
    if [[ ! -d "$SNAPFILE_DIR" ]]; then
        mkdir -p "$OBJECTS_DIR" "$SNAPSHOTS_DIR" "$INDEX_DIR"
        log_event "INFOS" "Repository initialized at $SNAPFILE_DIR"
        echo "✓ Dépôt SnapFile initialisé : $SNAPFILE_DIR"
    fi
}

# ============================================================================
# FONCTION : validate_target_dir()
# Vérifie que le chemin du dossier cible est fourni et valide
# ============================================================================
validate_target_dir() {
    if [[ -z "$TARGET_DIR" ]]; then
        die 101 "Paramètre manquant : vous devez spécifier un chemin de dossier"
    fi

    if [[ ! -e "$TARGET_DIR" ]]; then
        die 101 "Le chemin spécifié n'existe pas : $TARGET_DIR"
    fi

    if [[ ! -d "$TARGET_DIR" ]]; then
        die 101 "Le chemin spécifié n'est pas un dossier : $TARGET_DIR"
    fi
}
