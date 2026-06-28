#!/usr/bin/env bash
# deploy.sh — Build sur Pi 5, déploie sur Pi Zero 2 W
# Exécuter depuis Windows Git Bash ou Linux depuis la racine du projet :
#   bash scripts/deploy.sh
#
# Prérequis :
#   - clés SSH configurées : Windows → Pi 5, et Pi 5 → Pi Zero 2 W
#   - Qt 6 installé sur Pi 5
#   - rsync disponible (Git Bash for Windows l'inclut)

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
PI5_HOST="mafyou@192.168.1.229"
PIZERO_HOST="mafyou@192.168.1.247"
APP_NAME="hairStyleBuddy"
REMOTE_SRC="/home/mafyou/Documents/hairStyleBuddy/${APP_NAME}"
REMOTE_BUILD="${REMOTE_SRC}/build"
DEPLOY_DIR="/home/mafyou/Documents/hairStyleBuddy/${APP_NAME}"

# Si Qt est installé via le Qt Installer (pas apt), décommenter et adapter :
# QT_PREFIX="/home/pi/Qt/6.5.3/gcc_arm64"
# CMAKE_EXTRA="-DCMAKE_PREFIX_PATH=${QT_PREFIX}"
CMAKE_EXTRA=""
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════"
echo "  hairStyleBuddy — Déploiement"
echo "══════════════════════════════════════════════"

# ── Étape 1 : sync source → Pi 5 ─────────────────────────────────────────────
echo ""
echo "▶ [1/3] Synchronisation du code vers Pi 5 (${PI5_HOST})..."
rsync -avz --progress \
    --exclude='.git' \
    --exclude='build' \
    --exclude='*.user' \
    . "${PI5_HOST}:${REMOTE_SRC}/"
echo "   ✓ Sources synchronisées"

# ── Étape 2 : build sur Pi 5 ─────────────────────────────────────────────────
echo ""
echo "▶ [2/3] Build sur Pi 5..."
ssh "$PI5_HOST" bash << ENDSSH
    set -e
    cd "${REMOTE_SRC}"
    mkdir -p build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release ${CMAKE_EXTRA}
    cmake --build . --parallel 4
    echo "   Build terminé : \$(ls -lh ${APP_NAME} | awk '{print \$5, \$9}')"
ENDSSH
echo "   ✓ Build réussi"

# ── Étape 3 : déploiement Pi 5 → Pi Zero 2 W ─────────────────────────────────
echo ""
echo "▶ [3/3] Déploiement vers Pi Zero 2 W (${PIZERO_HOST})..."
ssh "$PI5_HOST" bash << ENDSSH
    set -e
    ssh "$PIZERO_HOST" "mkdir -p ${DEPLOY_DIR}"
    scp "${REMOTE_BUILD}/${APP_NAME}" "${PIZERO_HOST}:${DEPLOY_DIR}/${APP_NAME}"
ENDSSH
echo "   ✓ Binaire déployé"

# ── Redémarrage de l'application sur Pi Zero 2 W ────────────────────────────
echo ""
echo "▶ Redémarrage de l'application sur Pi Zero 2 W..."
ssh "${PIZERO_HOST}" bash << 'ENDSSH' || true
    # Tuer l'instance en cours si elle tourne
    pkill -f hairStyleBuddy 2>/dev/null || true
    # Si systemd est configuré, recharger le service
    if systemctl is-enabled hairStyleBuddy.service &>/dev/null; then
        sudo systemctl restart hairStyleBuddy.service
        echo "   ✓ Service systemd redémarré"
    else
        echo "   ℹ  Pas de service systemd — démarrage manuel requis"
        echo "      Lance : sudo systemctl start hairStyleBuddy.service"
        echo "      Ou    : bash scripts/install-autostart.sh  (première fois)"
    fi
ENDSSH

echo ""
echo "══════════════════════════════════════════════"
echo "  Déploiement terminé avec succès ✓"
echo "══════════════════════════════════════════════"
echo ""
