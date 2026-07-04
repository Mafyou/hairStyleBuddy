#!/usr/bin/env bash
# deploy.sh — Synchronise le code et compile directement sur le Pi Zero 2 W
#
# Dev possible depuis : Windows 11 (Git Bash) ou Raspberry Pi 5 Ubuntu
# Compilation + exécution : Pi Zero 2 W uniquement
#
# Usage :
#   bash scripts/deploy.sh          (depuis Windows Git Bash ou Pi 5)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ── Configuration ──────────────────────────────────────────────────────────────
PIZERO_USER="mafyou"
PIZERO_IP="192.168.1.247"
PIZERO_HOST="${PIZERO_USER}@${PIZERO_IP}"

APP_NAME="hairStyleBuddy"
REMOTE_SRC="/home/${PIZERO_USER}/Documents/hairStyleBuddy/${APP_NAME}"
REMOTE_BUILD="${REMOTE_SRC}/build"

CMAKE_EXTRA=""
# Si Qt installé via Qt Installer (pas apt) :
# CMAKE_EXTRA="-DCMAKE_PREFIX_PATH=~/Qt/6.5.3/gcc_arm64"

# Pi Zero 2 W : 512 MB RAM — 1 seul job sinon le build plante.
BUILD_JOBS=1
# ──────────────────────────────────────────────────────────────────────────────

# ── Détection de l'environnement ──────────────────────────────────────────────
case "$(uname -s)" in
    Linux*)
        CURRENT_IP=$(hostname -I 2>/dev/null | awk '{print $1}') || CURRENT_IP=""
        if [[ "$CURRENT_IP" == "$PIZERO_IP" ]]; then
            MODE="local"   # script lancé depuis le Pi Zero lui-même
        else
            MODE="linux"   # Pi 5 ou autre machine Linux
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        MODE="windows"
        ;;
    *)
        MODE="windows"
        ;;
esac

# ── Sync source → Pi Zero 2 W ─────────────────────────────────────────────────
# rsync si disponible (rapide, incrémental), sinon tar|ssh (fonctionne partout)
sync_sources() {
    ssh "$PIZERO_HOST" "mkdir -p '${REMOTE_SRC}'"
    if command -v rsync &>/dev/null; then
        rsync -az --progress \
            --exclude='.git' --exclude='build' --exclude='*.user' \
            "${PROJECT_ROOT}/" "${PIZERO_HOST}:${REMOTE_SRC}/"
    else
        echo "   (rsync absent — tar|ssh utilisé)"
        tar czf - \
            --exclude='.git' --exclude='build' --exclude='*.user' \
            -C "${PROJECT_ROOT}" . \
            | ssh "$PIZERO_HOST" "tar xzf - -C '${REMOTE_SRC}'"
    fi
}

echo ""
echo "══════════════════════════════════════════════"
echo "  hairStyleBuddy — Build & Deploy  [${MODE}]"
echo "  Cible : ${PIZERO_HOST}"
echo "══════════════════════════════════════════════"

# ── Étape 1 : synchronisation (sauf si déjà sur le Pi Zero) ──────────────────
if [[ "$MODE" != "local" ]]; then
    echo ""
    echo "▶ [1/2] Synchronisation du code vers Pi Zero 2 W..."
    sync_sources
    echo "   ✓ Sources synchronisées vers ${REMOTE_SRC}"
fi

# ── Étape 2 : compilation sur Pi Zero 2 W ─────────────────────────────────────
echo ""
if [[ "$MODE" == "local" ]]; then
    echo "▶ [1/2] Compilation locale sur Pi Zero 2 W..."
    mkdir -p "${PROJECT_ROOT}/build"
    pushd "${PROJECT_ROOT}/build" > /dev/null
    cmake "${PROJECT_ROOT}" -DCMAKE_BUILD_TYPE=Release $CMAKE_EXTRA
    cmake --build . --parallel ${BUILD_JOBS}
    popd > /dev/null
else
    echo "▶ [2/2] Compilation sur Pi Zero 2 W via SSH..."
    echo "   ⚠  Pi Zero 2 W est lent à compiler — patience (2-10 min)..."
    ssh "$PIZERO_HOST" bash << ENDSSH
        set -e
        mkdir -p "${REMOTE_BUILD}"
        cd "${REMOTE_BUILD}"
        cmake "${REMOTE_SRC}" -DCMAKE_BUILD_TYPE=Release ${CMAKE_EXTRA}
        cmake --build . --parallel ${BUILD_JOBS}
        echo "   Taille du binaire : \$(du -sh "${APP_NAME}" | cut -f1)"
ENDSSH
fi
echo "   ✓ Compilation réussie"

# ── Lancement de l'application ────────────────────────────────────────────────
echo ""
echo "▶ Lancement de l'application sur Pi Zero 2 W..."
ssh "${PIZERO_HOST}" bash << 'ENDSSH' || true
    pkill -f hairStyleBuddy 2>/dev/null || true
    sleep 1

    if systemctl is-enabled hairStyleBuddy.service 2>/dev/null; then
        # sudo -n = sans mot de passe (si NOPASSWD configuré via install-autostart.sh)
        # fallback : echo password | sudo -S
        if ! sudo -n systemctl restart hairStyleBuddy.service 2>/dev/null; then
            echo "toto" | sudo -S systemctl restart hairStyleBuddy.service 2>/dev/null
        fi
        echo "   ✓ Service systemd redémarré"
    else
        # Démarrage direct en arrière-plan (avant installation du service)
        nohup bash -c '
            export QT_QPA_PLATFORM="linuxfb:fb=/dev/fb0:tty=/dev/tty1"
            export QT_QUICK_CONTROLS_STYLE=Basic
            export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0
            ~/Documents/hairStyleBuddy/hairStyleBuddy/build/hairStyleBuddy
        ' > /tmp/hairStyleBuddy.log 2>&1 &

        sleep 2
        if pgrep -f hairStyleBuddy > /dev/null; then
            echo "   ✓ App démarrée (PID: $(pgrep -f hairStyleBuddy))"
            echo "   Logs : tail -f /tmp/hairStyleBuddy.log"
            echo "   ℹ  Pour l'autostart au boot : bash ~/Documents/hairStyleBuddy/hairStyleBuddy/scripts/install-autostart.sh"
        else
            echo "   ✗ Échec du démarrage — voir les logs :"
            cat /tmp/hairStyleBuddy.log
        fi
    fi
ENDSSH

echo ""
echo "══════════════════════════════════════════════"
echo "  Terminé ✓"
echo "══════════════════════════════════════════════"
echo ""
