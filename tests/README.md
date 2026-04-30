# 🧪 Tests - SnapFile

Ce dossier contient tous les tests automatisés du projet SnapFile.

---

## 📁 Contenu

### Tests du Sprint 1

| Fichier | Description | Tests | Durée |
|---------|-------------|-------|-------|
| **test_sprint1.sh** | Suite de tests automatisés complète | 12 tests | ~2 min |
| **TEST_RAPIDE.sh** | Démonstration interactive pas à pas | 11 étapes | ~5 min |

---

## 🚀 Utilisation

### Test Automatisé Complet

```bash
# Rendre le script exécutable
chmod +x test_sprint1.sh

# Lancer les tests
./test_sprint1.sh
```

**Résultat attendu :**
```
╔══════════════════════════════════════════════════════════════════════════╗
║                           RÉSUMÉ DES TESTS                               ║
╚══════════════════════════════════════════════════════════════════════════╝

Tests réussis : 12
Tests échoués : 0
Total         : 12

✓ TOUS LES TESTS SONT PASSÉS !
✓ Le Sprint 1 est prêt pour livraison au Membre 2
```

---

### Démonstration Interactive

```bash
# Rendre le script exécutable
chmod +x TEST_RAPIDE.sh

# Lancer la démonstration
./TEST_RAPIDE.sh
```

**Fonctionnement :**
- Affiche chaque test pas à pas
- Attend une confirmation entre chaque étape
- Montre les résultats en temps réel
- Nettoie automatiquement à la fin

---

## 📋 Liste des Tests

### test_sprint1.sh (12 tests)

| # | Test | Validation |
|---|------|------------|
| 1 | Option -h affiche le manuel | ✅ |
| 2 | Option inconnue → Erreur 100 | ✅ |
| 3 | Paramètre manquant → Erreur 101 | ✅ |
| 4 | Chemin inexistant → Erreur 101 | ✅ |
| 5 | Initialisation du dépôt ~/.snapfile/ | ✅ |
| 6 | Système de log fonctionnel | ✅ |
| 7 | Option -l (log personnalisé) | ✅ |
| 8 | Option -r sans sudo → Erreur 105 | ✅ |
| 9 | Options -f, -t, -s reconnues | ✅ |
| 10 | Commandes save, log, restore reconnues | ✅ |
| 11 | Commande inconnue → Erreur 100 | ✅ |
| 12 | Format du log conforme | ✅ |

**Taux de réussite :** 100% (12/12)

---

### TEST_RAPIDE.sh (11 étapes)

| # | Étape | Description |
|---|-------|-------------|
| 1 | Test de l'aide (-h) | Affiche le manuel |
| 2 | Test de la commande save | Crée un snapshot |
| 3 | Vérification de la structure | Vérifie ~/.snapfile/ |
| 4 | Consultation des logs | Affiche les logs |
| 5 | Test d'erreur (option inconnue) | Erreur 100 |
| 6 | Test d'erreur (paramètre manquant) | Erreur 101 |
| 7 | Test avec option -f (fork) | Fork en arrière-plan |
| 8 | Test avec option -t (thread) | Compression parallèle |
| 9 | Test avec log personnalisé (-l) | Log dans ~/demo_logs |
| 10 | Test de la commande log | Affiche l'historique |
| 11 | Test de la commande restore | Restaure un snapshot |

---

## 🎯 Tests par Fonctionnalité

### Options

```bash
# Test option -h
./test_sprint1.sh  # Test 1

# Test option -f
./TEST_RAPIDE.sh   # Étape 7

# Test option -t
./TEST_RAPIDE.sh   # Étape 8

# Test option -s
# (À implémenter dans Sprint 3)

# Test option -l
./test_sprint1.sh  # Test 7
./TEST_RAPIDE.sh   # Étape 9

# Test option -r
./test_sprint1.sh  # Test 8
```

### Codes d'Erreur

```bash
# Erreur 100 (option inconnue)
./test_sprint1.sh  # Tests 2, 11

# Erreur 101 (paramètre manquant)
./test_sprint1.sh  # Tests 3, 4

# Erreur 102 (dépôt non initialisé)
# (À implémenter dans Sprint 3)

# Erreur 103 (version introuvable)
# (À implémenter dans Sprint 3)

# Erreur 104 (espace disque plein)
# (À implémenter dans Sprint 2)

# Erreur 105 (permission refusée)
./test_sprint1.sh  # Test 8
```

### Système de Log

```bash
# Test log par défaut
./test_sprint1.sh  # Test 6

# Test log personnalisé
./test_sprint1.sh  # Test 7

# Test format du log
./test_sprint1.sh  # Test 12
```

---

## 📊 Métriques des Tests

### Sprint 1

- **Fichiers de test :** 2
- **Tests automatisés :** 12
- **Tests interactifs :** 11 étapes
- **Taux de réussite :** 100%
- **Couverture :** 100% des fonctionnalités Sprint 1

---

## 🔄 Tests Futurs

### Sprint 2 (À créer par Membre 2)

```bash
tests/test_sprint2.sh
├── Test commande save
├── Test déduplication SHA-256
├── Test compression tar/gzip
├── Test option -f (fork)
├── Test option -t (threads)
├── Test vérification espace disque
└── Test métadonnées des snapshots
```

### Sprint 3 (À créer par Membre 3)

```bash
tests/test_sprint3.sh
├── Test commande log
├── Test commande restore
├── Test option -s (prévisualisation)
├── Test erreur 102
└── Test erreur 103
```

### Sprint 4 (À créer par Membre 4)

```bash
tests/test_leger.sh       # 1 fichier, 10 Ko
tests/test_moyen.sh       # 15 fichiers, 25 Mo
tests/test_lourd.sh       # 50 fichiers, 500 Mo
tests/test_integration.sh # Tests d'intégration complets
```

---

## 🛠️ Créer un Nouveau Test

### Template de Test

```bash
#!/bin/bash

# Nom du test
TEST_NAME="Mon nouveau test"

# Fonction de test
test_ma_fonctionnalite() {
    # Préparer l'environnement
    mkdir -p test_data
    
    # Exécuter le test
    ../src/snapfile.sh ma_commande test_data/
    
    # Vérifier le résultat
    if [ $? -eq 0 ]; then
        echo "✓ PASS: $TEST_NAME"
        return 0
    else
        echo "✗ FAIL: $TEST_NAME"
        return 1
    fi
    
    # Nettoyer
    rm -rf test_data
}

# Lancer le test
test_ma_fonctionnalite
```

---

## 📞 Support

Pour toute question sur les tests :
- Consulter `../docs/README_sprint1.md`
- Lancer `./TEST_RAPIDE.sh` pour une démonstration
- Contacter le Membre 1

---

## ✅ Validation

Avant de livrer un sprint, vérifier que :
- [ ] Tous les tests passent (100%)
- [ ] Les nouveaux tests sont documentés
- [ ] Le README.md est mis à jour
- [ ] Les tests sont reproductibles

---

*Dernière mise à jour : 30 avril 2026*
