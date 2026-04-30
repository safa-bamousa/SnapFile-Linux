# 📜 Code Source - SnapFile

Ce dossier contient le code source du projet SnapFile.

---

## 📁 Contenu

### `snapfile.sh` (350 lignes)

**Description :** Script principal du projet SnapFile

**Sections :**
- **Lignes 1-11** : Entête et informations du projet
- **Lignes 12-32** : Variables globales
- **Lignes 52-130** : Fonction `usage()` — Manuel d'aide
- **Lignes 134-162** : Fonction `log_event()` — Système de log
- **Lignes 166-184** : Fonction `die()` — Gestion des erreurs
- **Lignes 206-214** : Fonction `init_repository()` — Initialisation du dépôt
- **Lignes 218-232** : Fonction `validate_target_dir()` — Validation du chemin
- **Lignes 236-242** : Fonction `check_sudo()` — Vérification des privilèges
- **Lignes 246-280** : Fonction `reset_snapfile()` — Réinitialisation
- **Lignes 264-295** : Parseur d'options (getopts)
- **Lignes 318-343** : Routage des commandes (save, log, restore)

---

## 🎯 Fonctionnalités Implémentées (Sprint 1)

### Options
- ✅ `-h` : Affiche le manuel complet
- ✅ `-f` : Fork (sauvegarde en arrière-plan)
- ✅ `-t` : Thread (compression parallèle)
- ✅ `-s` : Subshell (prévisualisation)
- ✅ `-l <chemin>` : Log personnalisé
- ✅ `-r` : Reset (réinitialisation complète)

### Commandes
- 🔄 `save <dossier>` : Crée un snapshot (à implémenter Sprint 2)
- 🔄 `log <dossier>` : Affiche l'historique (à implémenter Sprint 3)
- 🔄 `restore <dossier> --id N` : Restaure un snapshot (à implémenter Sprint 3)

### Fonctions Utilitaires
- ✅ `usage()` : Affiche l'aide
- ✅ `log_event()` : Enregistre dans le log
- ✅ `die()` : Gestion des erreurs
- ✅ `init_repository()` : Crée ~/.snapfile/
- ✅ `validate_target_dir()` : Valide le chemin
- ✅ `check_sudo()` : Vérifie les privilèges root
- ✅ `reset_snapfile()` : Réinitialise tout

---

## 🔧 Utilisation

```bash
# Rendre le script exécutable
chmod +x snapfile.sh

# Afficher l'aide
./snapfile.sh -h

# Créer un snapshot
./snapfile.sh save mon_projet/

# Avec options
./snapfile.sh -f save mon_projet/        # Fork
./snapfile.sh -t save mon_projet/        # Threads
./snapfile.sh -l ~/logs save mon_projet/ # Log personnalisé
```

---

## 📊 Métriques

- **Lignes de code :** 350 lignes
- **Fonctions :** 7 fonctions
- **Options :** 6 options
- **Codes d'erreur :** 6 codes (100-105)

---

## 🔄 Prochaines Étapes (Sprint 2)

Le Membre 2 doit implémenter la commande `save` à la **ligne 318** :

```bash
case "$COMMAND" in
    save)
        log_event "INFOS" "COMMAND: save $TARGET_DIR (fork=$OPT_FORK, thread=$OPT_THREAD)"
        
        # TODO SPRINT 2 : IMPLÉMENTER LA SAUVEGARDE ICI
        # 1. Parcours récursif avec find
        # 2. Calcul SHA-256 avec sha256sum
        # 3. Déduplication (liens symboliques)
        # 4. Compression avec tar/gzip
        # 5. Métadonnées des snapshots
        # 6. Vérification espace disque
        ;;
```

---

## 📚 Documentation

- **Documentation technique :** `../docs/README_sprint1.md`
- **Guide Sprint 2 :** `../docs/POUR_SPRINT2.md`
- **Tests :** `../tests/test_sprint1.sh`

---

*Dernière mise à jour : 30 avril 2026*
