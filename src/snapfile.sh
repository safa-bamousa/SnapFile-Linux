#!/bin/bash

################################################################################
# SnapFile - Système de versionnement léger pour utilisateurs non-développeurs
# Sprint 1 : Initialisation & Architecture du script
# Auteur : Membre 1
# Date : 30 avril 2026
################################################################################

# ============================================================================
# VARIABLES GLOBALES
# ============================================================================

# Version du script
VERSION="1.0.0"

# Répertoire de stockage des snapshots
SNAPFILE_DIR="$HOME/.snapfile"
OBJECTS_DIR="$SNAPFILE_DIR/objects"
SNAPSHOTS_DIR="$SNAPFILE_DIR/snapshots"
INDEX_DIR="$SNAPFILE_DIR/index"

# Fichier de log par défaut
DEFAULT_LOG_FILE="/var/log/snapfile/history.log"
LOG_FILE="$DEFAULT_LOG_FILE"

# Options activées (flags)
OPT_FORK=0
OPT_THREAD=0
OPT_SUBSHELL=0
OPT_RESET=0

# Paramètre obligatoire : chemin du dossier
TARGET_DIR=""

# ============================================================================
# FONCTION : usage()
# Description : Affiche le manuel complet du script (option -h)
# ============================================================================
usage() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║                            SNAPFILE v1.0.0                               ║
║          Système de versionnement léger pour fichiers locaux            ║
╚══════════════════════════════════════════════════════════════════════════╝

SYNOPSIS
    snapfile [OPTIONS] <commande> <dossier>

DESCRIPTION
    SnapFile est un outil de versionnement transparent qui capture des
    instantanés horodatés de vos dossiers. Il utilise la déduplication
    par hash SHA-256 pour économiser l'espace disque.

COMMANDES
    save <dossier>              Crée un nouveau snapshot du dossier
    log <dossier>               Affiche l'historique des snapshots
    restore <dossier> --id N    Restaure le snapshot N

OPTIONS
    -h                          Affiche ce manuel d'aide
    -f                          Fork : exécute la sauvegarde en arrière-plan
    -t                          Thread : compression parallèle des fichiers
    -s                          Subshell : restauration en prévisualisation
                                (dans /tmp/ sans écraser l'original)
    -l <chemin>                 Spécifie un répertoire de logs personnalisé
    -r                          Reset : réinitialise la configuration
                                (nécessite sudo)

EXEMPLES
    # Créer un snapshot simple
    snapfile save mon_projet/

    # Sauvegarde en arrière-plan
    snapfile -f save mon_projet/

    # Sauvegarde avec compression parallèle
    snapfile -t save gros_projet/

    # Consulter l'historique
    snapfile log mon_projet/

    # Restaurer une version (prévisualisation)
    snapfile -s restore mon_projet/ --id 3

    # Restaurer définitivement
    snapfile restore mon_projet/ --id 3

    # Réinitialiser complètement SnapFile
    sudo snapfile -r

CODES D'ERREUR
    100    Option non reconnue
    101    Paramètre manquant (chemin du dossier)
    102    Dépôt non initialisé (aucun snapshot trouvé)
    103    Version introuvable (ID de snapshot inexistant)
    104    Espace disque insuffisant
    105    Permission refusée (option -r nécessite sudo)

FICHIERS
    ~/.snapfile/objects/        Fichiers dédupliqués (stockage par hash)
    ~/.snapfile/snapshots/      Métadonnées des snapshots
    ~/.snapfile/index/          Mapping hash → chemin
    /var/log/snapfile/          Logs des opérations

FORMAT DES LOGS
    yyyy-mm-dd-hh-mm-ss: username: TYPE: message

    Exemples :
    2026-04-30-09-15-22: alice: INFOS: SNAPSHOT_CREATED id=5 files=12 size=45M
    2026-04-30-09-18-10: alice: INFOS: RESTORE_APPLIED id=3
    2026-04-30-10-05-33: bob: ERROR: ERROR_103 id=99 reason=not_found

AUTEUR
    Projet SnapFile - Théorie des Systèmes d'Exploitation
    Module : SE Windows/Unix/Linux

EOF
}

# ============================================================================
# FONCTION : log_event()
# Description : Enregistre un événement dans le fichier de log
# Arguments :
#   $1 - TYPE (INFOS, ERROR, WARNING)
#   $2 - Message à logger
# ============================================================================
log_event() {
    local type="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
    local username=$(whoami)
    local log_entry="${timestamp}: ${username}: ${type}: ${message}"
    
    # Créer le répertoire de log si nécessaire
    local log_dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$log_dir" ]]; then
        # Tenter de créer avec sudo si nécessaire
        if mkdir -p "$log_dir" 2>/dev/null; then
            :
        elif sudo mkdir -p "$log_dir" 2>/dev/null; then
            sudo chmod 777 "$log_dir"
        else
            # Fallback vers un log local
            LOG_FILE="$HOME/.snapfile/snapfile.log"
            log_dir="$HOME/.snapfile"
            mkdir -p "$log_dir" 2>/dev/null
        fi
    fi
    
    # Écrire dans le log et afficher simultanément avec tee
    echo "$log_entry" | tee -a "$LOG_FILE" 2>/dev/null || echo "$log_entry" >> "$LOG_FILE"
}

# ============================================================================
# FONCTION : die()
# Description : Gestion unifiée des erreurs
# Arguments :
#   $1 - Code d'erreur (100-105)
#   $2 - Message d'erreur
# ============================================================================
die() {
    local error_code="$1"
    local error_message="$2"
    
    # Logger l'erreur
    log_event "ERROR" "ERROR_${error_code}: ${error_message}"
    
    # Afficher l'erreur en rouge
    echo -e "\n❌ ERREUR ${error_code}: ${error_message}\n" >&2
    
    # Afficher l'aide automatiquement
    usage
    
    # Quitter avec le code d'erreur
    exit "$error_code"
}

# ============================================================================
# FONCTION : init_repository()
# Description : Crée la structure du dépôt ~/.snapfile/ si elle n'existe pas
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
# Description : Valide que le chemin du dossier cible existe
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

# ============================================================================
# FONCTION : check_sudo()
# Description : Vérifie que le script est exécuté avec sudo (pour option -r)
# ============================================================================
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        die 105 "L'option -r nécessite les privilèges administrateur (sudo)"
    fi
}

# ============================================================================
# FONCTION : reset_snapfile()
# Description : Réinitialise complètement SnapFile (option -r)
# ============================================================================
reset_snapfile() {
    check_sudo
    
    echo "⚠️  ATTENTION : Cette opération va supprimer TOUS les snapshots !"
    echo "Dossier à purger : $SNAPFILE_DIR"
    echo "Logs à effacer : /var/log/snapfile/"
    echo ""
    read -p "Êtes-vous sûr ? (tapez 'OUI' pour confirmer) : " confirmation
    
    if [[ "$confirmation" != "OUI" ]]; then
        echo "Opération annulée."
        exit 0
    fi
    
    # Purger le dépôt
    if [[ -d "$SNAPFILE_DIR" ]]; then
        rm -rf "$SNAPFILE_DIR"
        echo "✓ Dépôt $SNAPFILE_DIR supprimé"
    fi
    
    # Purger les logs
    if [[ -d "/var/log/snapfile" ]]; then
        rm -rf "/var/log/snapfile"
        echo "✓ Logs /var/log/snapfile/ supprimés"
    fi
    
    log_event "INFOS" "RESET_COMPLETE: All snapshots and logs purged"
    echo ""
    echo "✓ Réinitialisation terminée avec succès"
    exit 0
}

# ============================================================================
# PARSEUR D'OPTIONS (getopts)
# ============================================================================

# Si aucun argument, afficher l'aide
if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

# Parser les options
while getopts ":hftsl:r" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        f)
            OPT_FORK=1
            ;;
        t)
            OPT_THREAD=1
            ;;
        s)
            OPT_SUBSHELL=1
            ;;
        l)
            LOG_FILE="$OPTARG/snapfile.log"
            ;;
        r)
            OPT_RESET=1
            ;;
        \?)
            die 100 "Option non reconnue : -$OPTARG"
            ;;
        :)
            die 101 "L'option -$OPTARG nécessite un argument"
            ;;
    esac
done

# Décaler les arguments pour accéder aux paramètres positionnels
shift $((OPTIND - 1))

# ============================================================================
# TRAITEMENT DE L'OPTION -r (RESET)
# ============================================================================
if [[ $OPT_RESET -eq 1 ]]; then
    reset_snapfile
fi

# ============================================================================
# VALIDATION DU PARAMÈTRE OBLIGATOIRE
# ============================================================================

# Récupérer la commande (save, log, restore)
COMMAND="$1"
shift

# Récupérer le dossier cible
TARGET_DIR="$1"

# Valider que le dossier est fourni
validate_target_dir

# ============================================================================
# INITIALISATION DU DÉPÔT
# ============================================================================
init_repository

# ============================================================================
# ROUTAGE DES COMMANDES
# ============================================================================

case "$COMMAND" in
    save)
        log_event "INFOS" "COMMAND: save $TARGET_DIR (fork=$OPT_FORK, thread=$OPT_THREAD)"
        echo "🔄 Commande 'save' détectée pour : $TARGET_DIR"
        echo "⚠️  Fonctionnalité à implémenter dans le Sprint 2 (Membre 2)"
        ;;
    log)
        log_event "INFOS" "COMMAND: log $TARGET_DIR"
        echo "📋 Commande 'log' détectée pour : $TARGET_DIR"
        echo "⚠️  Fonctionnalité à implémenter dans le Sprint 3 (Membre 3)"
        ;;
    restore)
        log_event "INFOS" "COMMAND: restore $TARGET_DIR (subshell=$OPT_SUBSHELL)"
        echo "♻️  Commande 'restore' détectée pour : $TARGET_DIR"
        echo "⚠️  Fonctionnalité à implémenter dans le Sprint 3 (Membre 3)"
        ;;
    *)
        die 100 "Commande inconnue : $COMMAND (commandes valides : save, log, restore)"
        ;;
esac

# ============================================================================
# FIN DU SCRIPT
# ============================================================================
log_event "INFOS" "Script execution completed successfully"
echo ""
echo "✓ Exécution terminée avec succès"
exit 0
