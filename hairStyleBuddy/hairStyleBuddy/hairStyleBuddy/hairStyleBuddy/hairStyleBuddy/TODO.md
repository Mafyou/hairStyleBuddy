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

## Infrastructure — Pi 5 (machine de build)

- [ ] Installer Qt 6.5+ et les modules nécessaires :
  ```bash
  sudo apt update
  sudo apt install qt6-base-dev qt6-declarative-dev qml6-module-qtquick \
                   qml6-module-qtquick-controls qml6-module-qtquick-layouts \
                   libqt6sql6-sqlite cmake ninja-build
  ```
- [ ] Vérifier que CMake trouve Qt 6 :
  ```bash
  cmake --find-package -DNAME=Qt6 -DCOMPILER_ID=GNU -DLANGUAGE=CXX -DMODE=EXIST
  ```
- [ ] Configurer les clés SSH depuis Windows vers Pi 5 (pour rsync sans mot de passe) :
  ```powershell
  ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_hairbuddy"
  ssh-copy-id -i "$env:USERPROFILE\.ssh\id_hairbuddy.pub" pi@192.168.1.231
  ```
- [ ] Faire un premier build manuel pour valider l'environnement :
  ```bash
  cd ~/hairStyleBuddy
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  cmake --build build --parallel 4
  ```
- [ ] Configurer les clés SSH depuis Pi 5 vers Pi Zero 2 W (pour `scp` dans le script) :
  ```bash
  ssh-keygen -t ed25519
  ssh-copy-id pi@192.168.1.247
  ```

---

## Infrastructure — Pi Zero 2 W (machine cible)

- [ ] Installer les bibliothèques Qt runtime (même version que Pi 5) :
  ```bash
  sudo apt install libqt6quick6 libqt6quickcontrols2-6 libqt6sql6 libqt6sql6-sqlite
  ```
- [ ] Vérifier que le driver EGLFS fonctionne :
  ```bash
  QT_QPA_PLATFORM=eglfs ./hairStyleBuddy
  ```
  Si erreur EGL → essayer `QT_QPA_PLATFORM=linuxfb`
- [ ] Calibrer l'écran tactile résistif :
  ```bash
  sudo apt install evtest xinput
  evtest   # identifier le device /dev/input/eventX du touchscreen
  sudo apt install libts-bin
  ts_calibrate
  ```
- [ ] Configurer la rotation d'écran si nécessaire dans `/boot/firmware/config.txt` :
  ```
  display_rotate=1   # 0=normal 1=90° 2=180° 3=270°
  ```
- [ ] Installer le service autostart (voir `scripts/install-autostart.sh`)
- [ ] Tester le démarrage automatique au reboot : `sudo reboot`

---

## Déploiement (pipeline complet)

- [ ] S'assurer que Git est configuré sur Pi 5 (`git config --global user.email ...`)
- [ ] Tester le script `scripts/deploy.sh` depuis Windows Git Bash une première fois manuellement étape par étape
- [ ] Valider la fluidité tactile et le fullscreen sur Pi Zero 2 W
- [ ] Valider le comportement au démarrage à froid (SQLite, premier lancement)

---

## V2 — Nice to have (après V1 stable)

- [ ] Fiches clientes : historique des visites par nom
- [ ] Gestion des prestations depuis l'app (ajout / modification / suppression)
- [ ] Export CSV des RDV de la semaine (partage par clé USB ou réseau)
- [ ] Synchronisation optionnelle Google Calendar (via API REST, nécessite réseau)
- [ ] Alerte sonore à l'heure du RDV (`QSoundEffect`)
- [ ] Thème sombre automatique selon l'heure
- [ ] Écran de bienvenue clientèle (mode borne, distinct du mode staff)
