#!/usr/bin/env bash
# install-autostart.sh — Configure le démarrage automatique sur Pi Zero 2 W
#
# Peut être lancé depuis Windows, Pi 5, ou directement sur le Pi Zero.
# Si lancé depuis une autre machine, le script se ré-exécute via SSH sur le Pi Zero.
#
# Usage :
#   bash scripts/install-autostart.sh

set -euo pipefail

PIZERO_USER="mafyou"
PIZERO_IP="192.168.1.247"
PIZERO_HOST="${PIZERO_USER}@${PIZERO_IP}"

APP_NAME="hairStyleBuddy"
APP_DIR="/home/${PIZERO_USER}/Documents/hairStyleBuddy/${APP_NAME}"
APP_BIN="${APP_DIR}/build/${APP_NAME}"
SERVICE_NAME="${APP_NAME}.service"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}"
TOUCH_DEVICE="/dev/input/event0"

# ── Détection de l'environnement ──────────────────────────────────────────────
case "$(uname -s)" in
    Linux*)
        CURRENT_IP=$(hostname -I 2>/dev/null | awk '{print $1}') || CURRENT_IP=""
        if [[ "$CURRENT_IP" == "$PIZERO_IP" ]]; then
            MODE="local"
        else
            MODE="linux"
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        MODE="windows"
        ;;
    *)
        MODE="windows"
        ;;
esac

# ── Si pas sur le Pi Zero : se ré-exécuter à distance via SSH ─────────────────
if [[ "$MODE" != "local" ]]; then
    echo ""
    echo "══════════════════════════════════════════════"
    echo "  hairStyleBuddy — Installation autostart"
    echo "  (délégation SSH vers ${PIZERO_HOST})"
    echo "══════════════════════════════════════════════"
    echo ""
    echo "▶ Connexion SSH au Pi Zero et exécution du script..."

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    ssh "$PIZERO_HOST" "bash -s" < "${SCRIPT_DIR}/install-autostart.sh"
    exit 0
fi

# ── Exécution locale sur le Pi Zero ───────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════"
echo "  hairStyleBuddy — Installation autostart"
echo "══════════════════════════════════════════════"

# Vérifier que le binaire existe
if [ ! -f "$APP_BIN" ]; then
    echo "ERREUR : Binaire introuvable à ${APP_BIN}"
    echo "Lance d'abord le script deploy.sh depuis ta machine Windows."
    exit 1
fi

echo ""
echo "▶ Configuration sudo sans mot de passe pour systemctl..."
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/journalctl" \
    | sudo tee /etc/sudoers.d/hairStyleBuddy > /dev/null
sudo chmod 440 /etc/sudoers.d/hairStyleBuddy
echo "   ✓ /etc/sudoers.d/hairStyleBuddy configuré"

echo ""
echo "▶ Création du service systemd : ${SERVICE_FILE}"

sudo tee "$SERVICE_FILE" > /dev/null << EOF
[Unit]
Description=HairStyle Buddy — Application staff salon
After=multi-user.target

[Service]
User=${PIZERO_USER}
SupplementaryGroups=video render input
WorkingDirectory=${APP_DIR}

Environment=QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:tty=/dev/tty1
Environment=QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=${TOUCH_DEVICE}
Environment=QT_QPA_EGLFS_HIDECURSOR=1
Environment=QT_QUICK_CONTROLS_STYLE=Basic

ExecStart=${APP_BIN}
Restart=on-failure
RestartSec=3

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "   ✓ Fichier service créé"

echo ""
echo "▶ Enregistrement du service systemd..."
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
echo "   ✓ Service enregistré (démarrage automatique activé)"

echo ""
echo "▶ Création du raccourci bureau..."
DESKTOP_DIR="${HOME}/Desktop"
DESKTOP_FILE="${DESKTOP_DIR}/hairStyleBuddy.desktop"
ICON_PATH="${APP_DIR}/assets/icon.svg"

mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE" << DESKTOPEOF
[Desktop Entry]
Version=1.0
Type=Application
Name=HairStyle Buddy
Comment=Gestion salon de coiffure
Icon=${ICON_PATH}
Exec=env QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:tty=/dev/tty1 QT_QUICK_CONTROLS_STYLE=Basic QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=${TOUCH_DEVICE} ${APP_BIN}
Terminal=false
Categories=Utility;
StartupNotify=false
DESKTOPEOF

chmod +x "$DESKTOP_FILE"

if command -v gio &>/dev/null; then
    gio set "$DESKTOP_FILE" metadata::trusted true 2>/dev/null || true
fi

echo "   ✓ Raccourci créé : ${DESKTOP_FILE}"

echo ""
echo "▶ Lancement de l'application..."
sudo systemctl restart "$SERVICE_NAME"
sleep 2
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "   ✓ Application démarrée (PID: $(systemctl show -p MainPID --value $SERVICE_NAME))"
else
    echo "   ✗ Échec du démarrage — logs :"
    sudo journalctl -u "$SERVICE_NAME" -n 20 --no-pager
fi

echo ""
echo "══════════════════════════════════════════════"
echo "  Installation terminée ✓"
echo "══════════════════════════════════════════════"
echo ""
echo "Commandes utiles :"
echo "  Voir les logs en direct : sudo journalctl -u ${APP_NAME} -f"
echo "  Redémarrer l'app        : sudo systemctl restart ${APP_NAME}"
echo "  Arrêter l'app           : sudo systemctl stop ${APP_NAME}"
echo "  Désactiver l'autostart  : sudo systemctl disable ${APP_NAME}"
echo ""
echo "Si l'écran reste noir, vérifier :"
echo "  - QT_QPA_PLATFORM : essayer 'eglfs' si 'linuxfb' ne fonctionne pas"
echo "  - TOUCH_DEVICE    : lancer 'evtest --list' pour trouver le bon event"
echo "  - Rotation écran  : ajouter 'display_rotate=X' dans /boot/firmware/config.txt"
echo ""
