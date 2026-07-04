# TODO — hairStyleBuddy

## V1 — Fonctionnalités à compléter

### Pages manquantes
- [ ] `qml/NotesPage.qml` — saisie et lecture des notes rapides (remplacer le placeholder dans Main.qml)
- [ ] `qml/QrCodePage.qml` — affichage d'un QR code statique (Instagram, Google Reviews, prise de RDV en ligne)
  - Utiliser `Image { source: "assets/qrcode.png" }` avec une image pré-générée, ou la lib `QZXing` / `libqrencode` si QR dynamique

### Fonctionnalités manquantes dans l'existant
- [ ] Ajouter un RDV depuis l'app (formulaire : heure, nom, prestation)
  - `LocalDbService::insertAppointment()`
  - Dialogue ou page dédiée `AddAppointmentPage.qml`
- [ ] Supprimer / annuler un RDV (swipe ou bouton long-press)
- [ ] Page paramètres staff : modifier le nom du salon (écrit dans `config.json` via `SettingsService`)
- [ ] Mode veille : écran d'accueil automatique après X min d'inactivité (`Timer` QML + `StackView.clear()`)
- [ ] Afficher le nombre de RDV du jour sur la tuile d'accueil (badge)

### Backend à compléter
- [ ] `LocalDbService::insertAppointment()` — méthode d'insertion manuelle
- [ ] `LocalDbService::deleteAppointment(int id)` — suppression
- [ ] `LocalDbService::recentNotes()` — lecture des notes rapides (pour NotesPage)
- [ ] Exposer `recentNotes` comme `QAbstractListModel` ou `QStringList` dans AppController

---

## Infrastructure — Pi Zero 2 W (compilation + exécution)

Le Pi Zero 2 W est la seule machine qui **compile et exécute** l'application.
Windows et Pi 5 ne servent qu'à éditer le code.

### Setup Qt (une seule fois)

- [ ] Installer Qt 6 dev + outils de build :
  ```bash
  sudo apt update
  sudo apt install qt6-base-dev qt6-declarative-dev \
                   qml6-module-qtquick qml6-module-qtquick-controls \
                   qml6-module-qtquick-layouts \
                   libqt6sql6-sqlite cmake ninja-build
  ```
- [ ] Augmenter le swap pour survivre à la compilation (512 MB RAM insuffisant seul) :
  ```bash
  sudo dphys-swapfile swapoff
  sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=512/' /etc/dphys-swapfile
  sudo dphys-swapfile setup && sudo dphys-swapfile swapon
  ```
- [ ] Valider le premier build :
  ```bash
  cd ~/Documents/hairStyleBuddy/hairStyleBuddy
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build --parallel 1   # 1 thread — le Pi Zero plante avec plus
  ```

### Setup SSH (une seule fois, depuis Windows ou Pi 5)

- [ ] Depuis Windows PowerShell :
  ```powershell
  ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_hairbuddy"
  type "$env:USERPROFILE\.ssh\id_hairbuddy.pub" | ssh mafyou@192.168.1.247 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```
- [ ] Depuis Pi 5 :
  ```bash
  ssh-keygen -t ed25519
  ssh-copy-id mafyou@192.168.1.247
  ```

### Setup écran et autostart

- [ ] Calibrer l'écran tactile résistif :
  ```bash
  sudo apt install evtest libts-bin
  evtest          # identifier /dev/input/eventX du touchscreen
  ts_calibrate
  ```
- [ ] Configurer la rotation d'écran si nécessaire (`/boot/firmware/config.txt`) :
  ```
  display_rotate=1   # 0=normal 1=90° 2=180° 3=270°
  ```
- [ ] Installer le service autostart : `bash scripts/install-autostart.sh`
- [ ] Tester le démarrage automatique : `sudo reboot`

---

## Infrastructure — Pi 5 Ubuntu (poste de dev, optionnel)

Le Pi 5 est un **poste de développement**, pas une machine de build.

- [ ] Cloner le repo : `git clone <url> ~/Documents/hairStyleBuddy/hairStyleBuddy`
- [ ] Configurer les clés SSH vers Pi Zero 2 W (voir section ci-dessus)
- [ ] Pour tester localement sur Pi 5 (optionnel) :
  ```bash
  sudo apt install qt6-base-dev qt6-declarative-dev libqt6sql6-sqlite cmake
  cmake -B build -DCMAKE_BUILD_TYPE=Debug
  cmake --build build --parallel 4
  QT_QPA_PLATFORM=xcb ./build/hairStyleBuddy
  ```

---

## Déploiement (pipeline)

- [ ] Tester `bash scripts/deploy.sh` depuis Windows Git Bash (première fois)
- [ ] Tester `bash scripts/deploy.sh` depuis le Pi 5
- [ ] Valider la fluidité tactile et le fullscreen sur Pi Zero 2 W
- [ ] Valider le comportement au démarrage à froid (SQLite, premier lancement)
- [ ] Réduire à `BUILD_JOBS=1` dans deploy.sh si OOM pendant compilation

---

## V2 — Nice to have (après V1 stable)

- [ ] Fiches clientes : historique des visites par nom
- [ ] Gestion des prestations depuis l'app (ajout / modification / suppression)
- [ ] Export CSV des RDV de la semaine (partage par clé USB ou réseau)
- [ ] Synchronisation optionnelle Google Calendar (via API REST, nécessite réseau)
- [ ] Alerte sonore à l'heure du RDV (`QSoundEffect`)
- [ ] Thème sombre automatique selon l'heure
- [ ] Écran de bienvenue clientèle (mode borne, distinct du mode staff)
