# hairStyleBuddy

Application staff pour salon de coiffure — interface tactile plein écran sur Raspberry Pi Zero 2 W.

## Machines

| Rôle        | Machine              | IP              |
|-------------|----------------------|-----------------|
| Dev         | Windows 11 / VS Code | —               |
| Build/test  | Raspberry Pi 5       | 192.168.1.231   |
| Production  | Raspberry Pi Zero 2W | 192.168.1.247   |

---

## Démarrage rapide

### 1. Prérequis sur le Pi 5 (une seule fois)

```bash
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev \
                 qml6-module-qtquick qml6-module-qtquick-controls \
                 qml6-module-qtquick-layouts \
                 libqt6sql6-sqlite cmake ninja-build
```

### 2. Configurer les clés SSH (une seule fois)

Depuis Windows PowerShell :
```powershell
# Générer une clé dédiée (appuyer sur Entrée deux fois quand demandé pour ne pas mettre de passphrase)
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_hairbuddy"

# Copier vers Pi 5
type "$env:USERPROFILE\.ssh\id_hairbuddy.pub" | ssh pi@192.168.1.231 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Depuis le Pi 5, vers le Pi Zero 2 W :
```bash
ssh-keygen -t ed25519 -N ""
ssh-copy-id pi@192.168.1.247
```

### 3. Déployer

```bash
# Depuis Windows Git Bash, à la racine du projet
bash scripts/deploy.sh
```

Ce script fait les 3 étapes automatiquement :
- Synchronise le code sur le Pi 5 (`rsync`)
- Lance `cmake` + `build` sur le Pi 5
- Copie le binaire sur le Pi Zero 2 W et redémarre le service

### 4. Configurer le démarrage automatique (une seule fois sur le Pi Zero 2 W)

```bash
ssh pi@192.168.1.247
bash ~/hairStyleBuddy/scripts/install-autostart.sh
```

---

## Build manuel sur le Pi 5

```bash
ssh pi@192.168.1.231
cd ~/hairStyleBuddy
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel 4
```

Si Qt est installé via le Qt Installer (pas `apt`), ajouter le prefix :
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=~/Qt/6.5.3/gcc_arm64
```

---

## Lancer manuellement sur le Pi Zero 2 W

```bash
ssh pi@192.168.1.247
cd ~/hairStyleBuddy

# Sans serveur X (mode production)
QT_QPA_PLATFORM=eglfs ./hairStyleBuddy

# Fallback si eglfs ne fonctionne pas
QT_QPA_PLATFORM=linuxfb ./hairStyleBuddy
```

---

## Commandes utiles sur le Pi Zero 2 W

```bash
# Voir les logs de l'app en direct
sudo journalctl -u hairStyleBuddy -f

# Redémarrer l'app
sudo systemctl restart hairStyleBuddy

# Arrêter l'app
sudo systemctl stop hairStyleBuddy

# Identifier le périphérique tactile
evtest --list

# Calibrer l'écran résistif
ts_calibrate
```

---

## Structure du projet

```
hairStyleBuddy/
├── CMakeLists.txt
├── src/
│   ├── main.cpp
│   └── backend/
│       ├── AppController.h / .cpp          ← exposé à QML comme appController
│       ├── models/
│       │   ├── AppointmentModel.h / .cpp   ← RDV du jour
│       │   └── ServiceModel.h / .cpp       ← prestations & tarifs
│       └── services/
│           ├── LocalDbService.h / .cpp     ← SQLite local
│           └── SettingsService.h / .cpp    ← config JSON
├── qml/
│   ├── Main.qml                            ← ApplicationWindow + StackView
│   ├── HomePage.qml                        ← écran d'accueil (4 tuiles)
│   ├── AppointmentsPage.qml                ← RDV du jour + arrivées
│   ├── ServicesPage.qml                    ← prestations & tarifs
│   ├── ActionTile.qml                      ← composant tuile tactile
│   └── PageHeader.qml                      ← en-tête avec bouton retour
└── scripts/
    ├── deploy.sh                           ← build Pi5 + déploiement Pi Zero
    └── install-autostart.sh               ← service systemd sur Pi Zero
```

---

## Données

SQLite stocké dans `~/.local/share/HairStyleBuddy/hairstylebuddy.db`.  
Config JSON dans `~/.config/HairStyleBuddy/config.json`.

Des données de démonstration (4 RDV aujourd'hui + 6 prestations) sont insérées automatiquement au premier lancement.

Pour repartir de zéro :
```bash
rm ~/.local/share/HairStyleBuddy/hairstylebuddy.db
```

---

## Ce qui reste à faire

Voir [TODO.md](TODO.md).
