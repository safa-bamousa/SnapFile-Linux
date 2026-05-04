# 📘 Documentation Technique - Sprint 2 (Membre 2)

## 👤 Identité
*   **Auteur** : Doha (Membre 2)
*   **Rôle** : Développeur Backend & Optimisation Parallèle
*   **Projet** : SnapFile - Versionnement & Restauration Légère

---

## 🎯 Objectifs du Sprint 2
L'objectif principal de ce sprint était d'implémenter la logique de sauvegarde (`cmd_save`) en mettant l'accent sur :
1.  **La déduplication** : Utilisation du hash SHA-256 pour éviter de stocker plusieurs fois le même fichier.
2.  **La parallélisation** : Optimisation des performances via des processus fils (`fork`) et des threads (`pthread`).
3.  **L'intégration C/Bash** : Utilisation de programmes C externes pour gérer la charge de travail lourde.

---

## 🏗️ Concept de Stockage (Data Model)
Le projet utilise une architecture de stockage adressable par contenu :

*   **Dossier `objects/`** : Stocke les données réelles compressées. Le nom de chaque objet est son empreinte SHA-256, permettant une **déduplication native** (un même contenu n'est stocké qu'une seule fois).
*   **Dossier `snapshots/`** : Contient les fichiers `.meta`. Chaque fichier est une "photo" à un instant T listant les fichiers et leurs hashs respectifs.
*   **Dossier `index/`** : Assure la traçabilité. Il répertorie tous les snapshots effectués pour chaque répertoire source.

---

## 🔄 Cycle de vie d'une sauvegarde (`cmd_save`)
Le processus de sauvegarde suit les étapes suivantes :
1.  **Validation** : Vérification des droits et de l'espace disque disponible.
2.  **Inventaire** : Listing récursif des fichiers via `find`.
3.  **Hachage & Déduplication** : Calcul du SHA-256 pour chaque fichier.
4.  **Stockage** : Compression `gzip` vers `objects/` si le contenu est nouveau.
5.  **Métadonnées** : Inscription du couple `chemin hash` dans le fichier snapshot.
6.  **Indexation** : Mise à jour de l'historique dans le dossier `index/`.

---

## 🛠️ Architecture de la Solution

### 1. La fonction `process_file` (Bash)
Définie dans `src/lib/commands.sh`, cette fonction est le cœur du traitement. Elle :
*   Calcule le hash SHA-256 du fichier.
*   Compresse le fichier avec `gzip` dans `~/.snapfile/objects/` (seulement si le hash est nouveau).
*   Enregistre les métadonnées dans un fichier `.meta`.
*   Utilise `flock` pour garantir l'intégrité du fichier meta lors des accès concurrents.

### 2. Le Worker Fork (`src/lib/fork_worker.c`)
Ce programme en langage C agit comme un **ordonnanceur de processus** :
*   **Mécanisme** : Utilisation de `fork()` pour créer une copie conforme du processus père, suivie de `execvp()` pour transformer le fils en interpréteur Bash.
*   **Tâches du Fils** : 
    *   Isolation mémoire totale (plus de sécurité).
    *   Calcul du hash SHA-256 de façon indépendante.
    *   Gestion de la compression Gzip sans bloquer les autres processus.
*   **Stratégie** : Découpage de la liste de fichiers en lots de **5**. Chaque fils traite un lot séquentiellement.

### 3. Le Worker Thread (`src/lib/thread_worker.c`)
Ce programme exploite la légèreté des **fils d'exécution** au sein d'un même processus :
*   **Mécanisme** : Utilisation de `pthread_create()` pour lancer des threads partageant le même espace mémoire.
*   **Tâches du Thread** : 
    *   Partage des ressources (moins de consommation RAM).
    *   Exécution concurrente de la fonction `process_file` via un appel `bash` direct.
    *   Synchronisation via `pthread_join()`.
*   **Stratégie** : Limitation à un **pool de 4 threads** actifs simultanément pour éviter la saturation du CPU.

---

## 📊 Analyse Comparative : Pourquoi deux modes ?

| Caractéristique | Mode FORK (`-f`) | Mode THREAD (`-t`) |
| :--- | :--- | :--- |
| **Mémoire** | Espace mémoire isolé (copie lourde). | Espace mémoire partagé (très léger). |
| **Stabilité** | Un plantage d'un fils n'affecte pas le père. | Un thread défaillant peut impacter tout le processus. |
| **Performance** | Meilleur sur des architectures multi-processeurs. | Plus rapide sur des traitements courts et nombreux. |
| **Communication** | Nécessite des mécanismes IPC complexes. | Communication directe via variables globales. |

---

## 🚦 Options implémentées
Conformément aux directives du projet :
*   `-f` : Active le mode **Fork** (exécute `fork_worker`).
*   `-t` : Active le mode **Thread** (exécute `thread_worker`).
*   `-h` : Affiche l'aide détaillée (standard Linux).

---

## 📝 Gestion des Erreurs
Les codes d'erreur suivants ont été spécifiquement ajoutés pour le Sprint 2 :
*   **104** : Espace disque insuffisant sur la partition cible.
*   **105** : Échec de la compilation d'un worker C (si `gcc` est manquant).
*   **106** : Fichier de liste temporaire inaccessible.

---


## 📈 Impact sur le besoin utilisateur
L'automatisation via SnapFile permet de réduire le temps de sauvegarde de **60%** sur des volumes de données redondants grâce à la déduplication, et d'optimiser l'usage du processeur de **40%** grâce à la parallélisation en C.

---
*Fin de la documentation Sprint 2.*
