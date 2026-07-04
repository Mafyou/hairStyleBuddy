# hairStyleBuddy

Application staff pour salon de coiffure — interface tactile plein écran sur Raspberry Pi Zero 2 W.

## Machines

| Rôle                 | Machine                 | IP              | User    |
|----------------------|-------------------------|-----------------|---------|
| Dev (édition code)   | Windows 11 / VS Code    | 192.168.1.131   | —       |
| Dev (édition code)   | Raspberry Pi 5 Ubuntu   | 192.168.1.229   | mafyou  |
| Compilation + appli  | Raspberry Pi Zero 2W    | 192.168.1.247   | mafyou  |

> Le Pi 5 et Windows sont des postes de **développement** uniquement.
> Le Pi Zero 2 W compile **et** exécute l'application.

---

## Démarrage rapide

### 1. Prérequis sur le Pi Zero 2 W (une seule fois)

Qt 6 doit être installé **sur le Pi Zero 2 W** (headers + libs pour compiler) :

```bash
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev \
                 qml6-module-qtquick qml6-module-qtquick-controls \
                 qml6-module-qtquick-layouts \
                 libqt6sql6-sqlite cmake ninja-build
```

> La compilation sur Pi Zero 2 W est lente (512 MB RAM, CPU 1 GHz).
> Ajouter du swap si le build échoue en mémoire :
> ```bash
> sudo dphys-swapfile swapoff
> sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=512/' /etc/dphys-swapfile
> sudo dphys-swapfile setup && sudo dphys-swapfile swapon
> ```

### 2. Configurer les clés SSH (une seule fois)

Depuis Windows PowerShell (vers Pi Zero 2 W) :
```powershell
# Générer une clé dédiée (appuyer sur Entrée deux fois pour pas de passphrase)
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_hairbuddy"

# Copier vers Pi Zero 2 W
type "$env:USERPROFILE\.ssh\id_hairbuddy.pub" | ssh mafyou@192.168.1.247 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Depuis le Pi 5 (vers Pi Zero 2 W) :
```bash
ssh-keygen -t ed25519
ssh-copy-id mafyou@192.168.1.247
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
ssh mafyou@192.168.1.247
bash ~/Documents/hairStyleBuddy/hairStyleBuddy/scripts/install-autostart.sh
```

---

## Build manuel directement sur le Pi Zero 2 W

```bash
ssh mafyou@192.168.1.247
cd ~/Documents/hairStyleBuddy/hairStyleBuddy
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel 1   # 1 seul thread — le Pi Zero plante avec plus
```

---

## Lancer manuellement sur le Pi Zero 2 W

```bash
ssh mafyou@192.168.1.247
cd ~/Documents/hairStyleBuddy/hairStyleBuddy/build

# Mode production (framebuffer direct)
QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:tty=/dev/tty1 ./hairStyleBuddy

# Fallback si linuxfb ne fonctionne pas
QT_QPA_PLATFORM=eglfs ./hairStyleBuddy
```

---

## Développement sur Pi 5

Le Pi 5 est un poste de dev comme Windows — on édite le code, puis on déploie sur Pi Zero :

```bash
# Depuis le Pi 5, dans le dossier du projet cloné
bash scripts/deploy.sh   # sync → Pi Zero, compile sur Pi Zero, lance l'app
```

Pour tester localement sur Pi 5 (optionnel, la résolution/touch sera différente) :
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel 4
QT_QPA_PLATFORM=xcb ./build/hairStyleBuddy   # si X11 disponible sur Pi 5
```

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

SQLite stocké dans `~/.local/share/HairStyleBuddy/hairstylebuddy.db` (sur Pi Zero 2 W).  
Config JSON dans `~/.config/HairStyleBuddy/config.json`.

Des données de démonstration (4 RDV aujourd'hui + 6 prestations) sont insérées automatiquement au premier lancement.

Pour repartir de zéro :
```bash
rm ~/.local/share/HairStyleBuddy/hairstylebuddy.db
```

---

## Ce qui reste à faire

Voir [TODO.md](TODO.md).
