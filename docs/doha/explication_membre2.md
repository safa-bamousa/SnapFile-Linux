# Explication du Code - Sprint 2 (Étapes 1 à 6)

Ce document explique de manière simple les modifications effectuées pour créer la commande `save`. Ce code est conçu pour être facile à lire et à comprendre.

## 1. Fichier Modifié
Le seul fichier modifié est **`src/lib/commands.sh`**. La fonction `cmd_save()` contient maintenant le code de sauvegarde.

## 2. Ce qui a été fait (Les 6 étapes simplifiées)

### Étape 1 : Vérification de l'espace disque
```bash
local avail_space=$(df -k "$TARGET_DIR" | tail -1 | awk '{print $4}')
if [ "$avail_space" -lt 51200 ]; then
    die 104 "Espace disque insuffisant pour effectuer la sauvegarde."
fi
```
**Explication** : La commande `df` donne l'espace disque. On utilise `tail` pour prendre la dernière ligne et `awk` pour récupérer la 4ème colonne (l'espace libre). Le symbole `<` s'écrit `-lt` en bash (less than). S'il y a moins de 50 Mo, on affiche une erreur.

### Étape 2 : Le parcours des fichiers
```bash
find "$TARGET_DIR" -type f > /tmp/liste_fichiers_snapfile.txt

while read file; do
   # ... code ...
done < /tmp/liste_fichiers_snapfile.txt
```
**Explication** : Plutôt que de faire une boucle très complexe, on utilise une méthode simple en 2 temps :
1. On trouve tous les fichiers avec `find` et on écrit cette liste dans un fichier texte temporaire (`/tmp/...`).
2. On lit ce fichier ligne par ligne avec `while read file`.

### Étape 3 : Calcul de l'empreinte (SHA-256)
```bash
local hash=$(sha256sum "$file" | awk '{print $1}')
local obj_path="$OBJECTS_DIR/${hash}.gz"
```
**Explication** : `sha256sum` génère un code unique pour le fichier. On utilise `awk` pour récupérer juste ce code. On prépare ensuite le chemin où on va enregistrer le fichier compressé.

### Étapes 4 et 5 : Sauvegarder sans dupliquer
```bash
if [ ! -f "$obj_path" ]; then
    gzip -c "$file" > "$obj_path"
fi
```
**Explication** : `[ ! -f "$obj_path" ]` veut dire "Si ce fichier n'existe pas encore". Si c'est le cas, on le compresse avec `gzip` et on le range. S'il existe déjà, le code ne fait rien du tout (c'est ça la déduplication !).

### Étape 6 : Noter ce qu'on a fait
```bash
local relative_path=$(echo "$file" | sed "s|$TARGET_DIR/||")
echo "$hash $relative_path" >> "$meta_file"
```
**Explication** : Pour avoir un joli chemin de fichier (sans le dossier parent), on utilise l'outil `sed` qui va simplement effacer `$TARGET_DIR/` du nom du fichier. 
Ensuite, on écrit le `hash` et le nom du fichier dans notre fichier de métadonnées (`$meta_file`) pour s'en souvenir.

### Nettoyage à la fin
```bash
rm /tmp/liste_fichiers_snapfile.txt
```
**Explication** : Une fois la boucle terminée, on supprime la liste temporaire qu'on avait créée à l'étape 2 pour laisser l'ordinateur propre.
