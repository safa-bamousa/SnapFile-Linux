#!/bin/bash
################################################################################
# commands.sh — Routage et dispatch des commandes
# Contient : run_command()
#
# Les implémentations réelles de chaque commande seront ajoutées
# par les membres suivants dans leurs sprints respectifs :
#   - cmd_save()    → Sprint 2 (Membre 2)
#   - cmd_log()     → Sprint 3 (Membre 3)
#   - cmd_restore() → Sprint 3 (Membre 3)
################################################################################

# ============================================================================
# FONCTION : cmd_save()
# Sauvegarde un dossier sous forme de snapshot
# Variables utilisées : $TARGET_DIR, $OPT_FORK, $OPT_THREAD
# TODO : à implémenter dans le Sprint 2
# ============================================================================
cmd_save() {
    log_event "INFOS" "COMMAND: save $TARGET_DIR (fork=$OPT_FORK, thread=$OPT_THREAD)"

    # =========================================================
    # TODO SPRINT 2 — Membre 2
    # =========================================================
    # 1. Vérifier l'espace disque disponible (die 104 si plein)
    # 2. Parcours récursif avec find
    # 3. Calcul SHA-256 de chaque fichier (sha256sum)
    # 4. Déduplication : ln -s si hash déjà dans objects/
    # 5. Compression : gzip vers objects/<hash>.gz
    # 6. Créer les métadonnées dans snapshots/
    # 7. Si OPT_FORK=1 : lancer en arrière-plan avec & + disown
    # 8. Si OPT_THREAD=1 : compression parallèle avec wait
    # 9. log_event "INFOS" "SNAPSHOT_CREATED id=N files=N size=NM"
    # =========================================================

    echo "🔄 [save] Dossier cible : $TARGET_DIR"
    echo "⚠️  À implémenter — Sprint 2 (Membre 2)"
}

# ============================================================================
# FONCTION : cmd_log()
# Affiche l'historique des snapshots d'un dossier
# Variables utilisées : $TARGET_DIR
# TODO : à implémenter dans le Sprint 3
# ============================================================================
cmd_log() {
    log_event "INFOS" "COMMAND: log $TARGET_DIR"

    # =========================================================
    # TODO SPRINT 3 — Membre 3
    # =========================================================
    # 1. Vérifier que ~/.snapfile/snapshots/ n'est pas vide (die 102)
    # 2. Lire les fichiers de métadonnées avec awk/grep
    # 3. Filtrer par nom de dossier source
    # 4. Afficher un tableau formaté : ID | Date | Fichiers | Taille
    # =========================================================

    echo "📋 [log] Dossier cible : $TARGET_DIR"
    echo "⚠️  À implémenter — Sprint 3 (Membre 3)"
}

# ============================================================================
# FONCTION : cmd_restore()
# Restaure un snapshot par son ID
# Variables utilisées : $TARGET_DIR, $OPT_SUBSHELL, $@
# TODO : à implémenter dans le Sprint 3
# ============================================================================
cmd_restore() {
    log_event "INFOS" "COMMAND: restore $TARGET_DIR (subshell=$OPT_SUBSHELL)"

    # =========================================================
    # TODO SPRINT 3 — Membre 3
    # =========================================================
    # 1. Parser --id N depuis les arguments restants
    # 2. Vérifier que l'ID existe (die 103 sinon)
    # 3. Lire les métadonnées du snapshot
    # 4. Reconstruire les fichiers depuis objects/ (gunzip)
    # 5. Si OPT_SUBSHELL=1 : restaurer dans /tmp/snapfile_preview/
    #    Sinon : restaurer directement dans TARGET_DIR
    # 6. log_event "INFOS" "RESTORE_APPLIED id=N"
    # =========================================================

    echo "♻️  [restore] Dossier cible : $TARGET_DIR"
    echo "⚠️  À implémenter — Sprint 3 (Membre 3)"
}

# ============================================================================
# FONCTION : run_command()
# Dispatch vers la bonne fonction selon $COMMAND
# ============================================================================
run_command() {
    case "$COMMAND" in
        save)
            cmd_save "$@"
            ;;
        log)
            cmd_log "$@"
            ;;
        restore)
            cmd_restore "$@"
            ;;
        *)
            die 100 "Commande inconnue : '$COMMAND'  (valides : save, log, restore)"
            ;;
    esac
}
