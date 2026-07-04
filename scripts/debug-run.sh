#!/usr/bin/env bash
# debug-run.sh — Lance hairStyleBuddy en mode debug sur Pi Zero 2 W
# Exécuter directement sur le Pi Zero :
#   bash scripts/debug-run.sh
#
# Options :
#   --qml-debug    Active le débogueur QML (port 3768, Qt Creator peut s'y connecter)
#   --fb           Force linuxfb (défaut)
#   --eglfs        Force eglfs à la place de linuxfb
#   --no-stop      Ne stoppe pas le service systemd avant de lancer

set -euo pipefail

APP_NAME="hairStyleBuddy"
# APP_DIR="/home/mafyou/Documents/hairStyleBuddy/${APP_NAME}"
APP_DIR="D:/source/hairStyleBuddy/${APP_NAME}"
APP_BIN="${APP_DIR}/build/${APP_NAME}"
SERVICE_NAME="${APP_NAME}.service"

QML_DEBUG=0
PLATFORM="linuxfb:fb=/dev/fb0:tty=/dev/tty1"
STOP_SERVICE=1

for arg in "$@"; do
    case "$arg" in
        --qml-debug) QML_DEBUG=1 ;;
        --eglfs)     PLATFORM="eglfs" ;;
        --fb)        PLATFORM="linuxfb:fb=/dev/fb0:tty=/dev/tty1" ;;
        --no-stop)   STOP_SERVICE=0 ;;
    esac
done

echo ""
echo "══════════════════════════════════════════════"
echo "  hairStyleBuddy — Mode debug"
echo "══════════════════════════════════════════════"

# Vérifier que le binaire existe
if [ ! -f "$APP_BIN" ]; then
    echo "ERREUR : Binaire introuvable à ${APP_BIN}"
    echo "Lance d'abord : cd ${APP_DIR}/build && cmake --build . --parallel 1"
    exit 1
fi

# Stopper le service pour éviter les conflits
if [ "$STOP_SERVICE" -eq 1 ]; then
    if systemctl is-active "$SERVICE_NAME" &>/dev/null; then
        echo "▶ Arrêt du service systemd..."
        sudo systemctl stop "$SERVICE_NAME"
        echo "   ✓ Service stoppé"
        RESTART_ON_EXIT=1
    else
        RESTART_ON_EXIT=0
    fi
else
    RESTART_ON_EXIT=0
fi

# Relancer le service au Ctrl+C
cleanup() {
    echo ""
    echo "▶ Arrêt de l'application..."
    if [ "${RESTART_ON_EXIT}" -eq 1 ]; then
        echo "▶ Redémarrage du service systemd..."
        sudo systemctl start "$SERVICE_NAME" && echo "   ✓ Service redémarré"
    fi
}
trap cleanup EXIT

echo ""
echo "▶ Lancement en mode debug (Ctrl+C pour quitter)"
echo "   Binaire  : ${APP_BIN}"
echo "   Platform : ${PLATFORM}"
[ "$QML_DEBUG" -eq 1 ] && echo "   QML debug: port 3768 (connecter Qt Creator)"
echo ""

# Variables d'environnement debug
export QT_QPA_PLATFORM="$PLATFORM"
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS="/dev/input/event0"
export QT_QPA_EGLFS_HIDECURSOR=1
export QT_QUICK_CONTROLS_STYLE=Basic
export QT_LOGGING_RULES="qt.qml.binding.removal.info=true;qt.quick.dirty=false"
export QML_IMPORT_TRACE=0

# Logs détaillés Qt
export QT_DEBUG_PLUGINS=1

# Lancer avec ou sans débogueur QML
if [ "$QML_DEBUG" -eq 1 ]; then
    exec "$APP_BIN" -qmljsdebugger=port:3768,block,services:DebugMessages,QmlDebugger,V8Debugger
else
    exec "$APP_BIN"
fi
