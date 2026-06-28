#!/usr/bin/env bash
# install-autostart.sh — Configure le démarrage automatique sur Pi Zero 2 W
# À exécuter UNE FOIS directement sur le Pi Zero 2 W :
#   bash scripts/install-autostart.sh
#
# Ce script :
#   1. Crée le service systemd pour lancer l'app au démarrage
#   2. Active le service
#   3. Affiche les commandes utiles

set -euo pipefail

APP_NAME="hairStyleBuddy"
APP_DIR="/home/mafyou/Documents/hairStyleBuddy/${APP_NAME}"
APP_BIN="${APP_DIR}/build/${APP_NAME}"
SERVICE_NAME="${APP_NAME}.service"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}"

# ── Adapter selon le touchscreen détecté ────────────────────────────────────
# Lister les périphériques d'entrée : evtest --list ou ls /dev/input/
TOUCH_DEVICE="/dev/input/event0"
# ─────────────────────────────────────────────────────────────────────────────

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
echo "▶ Création du service systemd : ${SERVICE_FILE}"

sudo tee "$SERVICE_FILE" > /dev/null << EOF
[Unit]
Description=HairStyle Buddy — Application staff salon
After=multi-user.target

[Service]
User=mafyou
SupplementaryGroups=video render input
WorkingDirectory=${APP_DIR}

# Plateforme graphique framebuffer direct
Environment=QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0:tty=/dev/tty1

# Périphérique tactile résistif — adapter /dev/input/eventX si besoin
Environment=QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=${TOUCH_DEVICE}

# Désactiver les curseurs inutiles sur résistif
Environment=QT_QPA_EGLFS_HIDECURSOR=1

# Style léger Qt Quick Controls
Environment=QT_QUICK_CONTROLS_STYLE=Basic


ExecStart=${APP_BIN}
Restart=on-failure
RestartSec=3

# Logs accessibles via : journalctl -u ${APP_NAME} -f
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "   ✓ Fichier service créé"

echo ""
echo "▶ Activation et démarrage du service..."
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"
echo "   ✓ Service activé et démarré"

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
echo "  - QT_QPA_PLATFORM : essayer 'linuxfb' si 'eglfs' ne fonctionne pas"
echo "  - TOUCH_DEVICE    : lancer 'evtest --list' pour trouver le bon event"
echo "  - Rotation écran  : ajouter 'display_rotate=X' dans /boot/firmware/config.txt"
echo ""
