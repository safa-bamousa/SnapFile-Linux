# 📸 SnapFile - Système de Versionnement Léger

**Version :** 1.0.0  
**Sprint Actuel :** 1/4 (Complet ✅)  
**Date :** 30 avril 2026

---

## 📋 Table des Matières

- [Description](#-description)
- [Structure du Projet](#-structure-du-projet)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Documentation](#-documentation)
- [Tests](#-tests)
- [Sprints](#-sprints)
- [Équipe](#-équipe)

---

## 🎯 Description

SnapFile est un système de versionnement transparent et léger pour utilisateurs non-développeurs. Il capture des instantanés horodatés de vos dossiers avec déduplication intelligente par hash SHA-256.

**Philosophie :** L'utilisateur continue à travailler normalement. SnapFile agit comme un photographe d'état qui capture des instantanés sur simple commande.

---

## 📁 Structure du Projet

```
SnapFile-linux/
├── src/                          # Code source
│   └── snapfile.sh              # Script principal (350 lignes)
│
├── docs/                         # Documentation
│   ├── README_sprint1.md        # Documentation technique Sprint 1
│   ├── GUIDE_DEMARRAGE.md       # Guide de démarrage rapide
│   ├── LIVRAISON_SPRINT1.md     # Rapport de livraison Sprint 1
│   ├── POUR_SPRINT2.md          # Guide pour le Membre 2
│   ├── RESUME_VISUEL.txt        # Résumé visuel
│   └── INSTRUCTIONS_LIVRAISON.md # Instructions de livraison
│
├── tests/                        # Tests automatisés
│   ├── test_sprint1.sh          # Suite de 12 tests Sprint 1
│   └── TEST_RAPIDE.sh           # Démonstration rapide interactive
│
├── examples/                     # Exemples et données de test
│   └── test_folder/             # Dossier de test exemple
│
├── .snapfile_config/             # Configuration (réservé)
│
└── README.md                     # Ce fichier
```

---

## 🚀 Installation

```bash
# Cloner ou accéder au projet
cd SnapFile-linux

# Rendre le script exécutable
chmod +x src/snapfile.sh

# Créer un alias (optionnel)
echo "alias snapfile='$(pwd)/src/snapfile.sh'" >> ~/.bashrc
source ~/.bashrc
```

---

## 📖 Utilisation

### Commandes de Base

```bash
# Afficher l'aide
./src/snapfile.sh -h

# Créer un snapshot
./src/snapfile.sh save mon_projet/

# Consulter l'historique
./src/snapfile.sh log mon_projet/

# Restaurer une version
./src/snapfile.sh restore mon_projet/ --id 3
```

### Options Avancées

```bash
# Sauvegarde en arrière-plan
./src/snapfile.sh -f save mon_projet/

# Compression parallèle (pour gros projets)
./src/snapfile.sh -t save gros_projet/

# Restauration en prévisualisation (sans risque)
./src/snapfile.sh -s restore mon_projet/ --id 3

# Log personnalisé
./src/snapfile.sh -l ~/mes_logs save mon_projet/

# Réinitialisation complète
sudo ./src/snapfile.sh -r
```

---

## 📚 Documentation

### Documentation Principale

| Document | Description |
|----------|-------------|
| **[README_sprint1.md](docs/README_sprint1.md)** | Documentation technique complète du Sprint 1 |
| **[GUIDE_DEMARRAGE.md](docs/GUIDE_DEMARRAGE.md)** | Guide de démarrage rapide |
| **[LIVRAISON_SPRINT1.md](docs/LIVRAISON_SPRINT1.md)** | Rapport de livraison officiel |

### Documentation pour les Développeurs

| Document | Destinataire |
|----------|--------------|
| **[POUR_SPRINT2.md](docs/POUR_SPRINT2.md)** | Membre 2 (Sprint 2) |
| **[INSTRUCTIONS_LIVRAISON.md](docs/INSTRUCTIONS_LIVRAISON.md)** | Membre 1 (Livraison) |
| **[RESUME_VISUEL.txt](docs/RESUME_VISUEL.txt)** | Résumé visuel |

---

## 🧪 Tests

### Lancer les Tests

```bash
# Test rapide interactif (recommandé pour démo)
chmod +x tests/TEST_RAPIDE.sh
./tests/TEST_RAPIDE.sh

# Suite de tests complète (12 tests automatisés)
chmod +x tests/test_sprint1.sh
./tests/test_sprint1.sh
```

### Résultats Attendus

- ✅ **12/12 tests réussis** (100%)
- ✅ Tous les codes d'erreur validés (100-105)
- ✅ Toutes les options fonctionnelles (-h, -f, -t, -s, -l, -r)

---

## 🎯 Sprints

### ✅ Sprint 1 : Initialisation & Architecture (COMPLET)

**Responsable :** Membre 1  
**Statut :** ✅ 100% Complet et Validé

**Livrables :**
- ✅ Script principal avec squelette fonctionnel
- ✅ Fonction `usage()` (option `-h`)
- ✅ Parseur d'options avec `getopts`
- ✅ Validation du paramètre obligatoire
- ✅ Structure du dépôt `~/.snapfile/`
- ✅ Système de log au format standardisé
- ✅ Gestion unifiée des erreurs (codes 100-105)
- ✅ Documentation complète (7 fichiers)
- ✅ Suite de tests (12 tests)

**Métriques :**
- Lignes de code : 350
- Fonctions : 7
- Tests : 12 (100% réussis)

---

### 🔄 Sprint 2 : Sauvegarde & Déduplication (EN COURS)

**Responsable :** Membre 2  
**Statut :** 📋 À démarrer

**Objectifs :**
- Commande `save` avec parcours récursif
- Calcul SHA-256 de chaque fichier
- Déduplication par hash (liens symboliques)
- Compression avec tar/gzip
- Métadonnées des snapshots
- Option `-f` (fork en arrière-plan)
- Option `-t` (compression parallèle)
- Vérification espace disque (erreur 104)

**Documentation :** [POUR_SPRINT2.md](docs/POUR_SPRINT2.md)

---

### 📋 Sprint 3 : Consultation & Restauration (À VENIR)

**Responsable :** Membre 3  
**Statut :** ⏳ En attente du Sprint 2

**Objectifs :**
- Commande `log` (historique des snapshots)
- Commande `restore` (restauration)
- Option `-s` (prévisualisation dans /tmp/)
- Option `-r` (reset complet)
- Gestion des erreurs 102 et 103

---

### 🧪 Sprint 4 : Tests & Finition (À VENIR)

**Responsable :** Membre 4  
**Statut :** ⏳ En attente du Sprint 3

**Objectifs :**
- Tests complets (léger, moyen, lourd)
- Mesures de performance
- Corrections de bugs
- Rapport final
- Démonstration

---

## 🤝 Équipe

| Membre | Sprint | Responsabilité | Statut |
|--------|--------|----------------|--------|
| **Membre 1** | Sprint 1 | Initialisation & Architecture | ✅ Complet |
| **Membre 2** | Sprint 2 | Sauvegarde & Déduplication | 🔄 En cours |
| **Membre 3** | Sprint 3 | Consultation & Restauration | 📋 À venir |
| **Membre 4** | Sprint 4 | Tests & Finition | 🧪 À venir |

---

## 📊 Métriques Globales

### Sprint 1 (Actuel)

- **Lignes de code :** 350 lignes
- **Fonctions créées :** 7 fonctions
- **Options implémentées :** 6 options
- **Codes d'erreur :** 6 codes (100-105)
- **Tests automatisés :** 12 tests
- **Taux de réussite :** 100%
- **Documentation :** 7 fichiers

---

## 🏗️ Architecture Technique

### Structure du Dépôt

```
~/.snapfile/
├── objects/        # Fichiers dédupliqués (stockage par hash SHA-256)
├── snapshots/      # Métadonnées des snapshots
└── index/          # Mapping hash → chemin original
```

### Codes d'Erreur

| Code | Signification |
|------|---------------|
| 100 | Option non reconnue |
| 101 | Paramètre manquant (chemin du dossier) |
| 102 | Dépôt non initialisé (aucun snapshot trouvé) |
| 103 | Version introuvable (ID de snapshot inexistant) |
| 104 | Espace disque insuffisant |
| 105 | Permission refusée (option -r nécessite sudo) |

### Format des Logs

```
yyyy-mm-dd-hh-mm-ss: username: TYPE: message
```

**Exemple :**
```
2026-04-30-14-23-45: alice: INFOS: SNAPSHOT_CREATED id=5 files=12 size=45M
```

---

## 🔧 Configuration

### Variables d'Environnement (Futures)

```bash
export SNAPFILE_DIR="$HOME/.snapfile"
export SNAPFILE_LOG="/var/log/snapfile/history.log"
```

### Fichier de Configuration (Futur)

`.snapfile_config/config.json` (à implémenter dans les sprints futurs)

---

## 📄 Licence

Projet académique - Théorie des Systèmes d'Exploitation  
Module : SE Windows/Unix/Linux  
Date : 18 avril 2026

---

## 📞 Support

### Pour les Utilisateurs

- Consulter [GUIDE_DEMARRAGE.md](docs/GUIDE_DEMARRAGE.md)
- Lancer `./src/snapfile.sh -h`

### Pour les Développeurs

- Sprint 1 : [README_sprint1.md](docs/README_sprint1.md)
- Sprint 2 : [POUR_SPRINT2.md](docs/POUR_SPRINT2.md)
- Tests : `./tests/test_sprint1.sh`

---

## ✅ Statut du Projet

**Sprint 1 : 100% Complet et Validé ✅**  
**Prêt pour livraison au Membre 2 🚀**

---

*Dernière mise à jour : 30 avril 2026*
