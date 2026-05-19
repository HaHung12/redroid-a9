#!/bin/bash
# Khởi động Redroid A9 + auto-optimize
set -e

cd "$(dirname "$(readlink -f "$0")")"

echo "[+] Starting Redroid A9..."
docker compose up -d

echo "[+] Waiting 90s for boot..."
sleep 90

adb disconnect 2>/dev/null || true
adb connect localhost:5557
sleep 3

BOOT=$(adb -s localhost:5557 shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
if [ "$BOOT" = "1" ]; then
    echo "[+] ✓ Container booted"
    docker stats redroid-a9 --no-stream | grep redroid
    
    echo ""
    echo "[+] Auto-running optimize.sh..."
    ./optimize.sh
    
    echo ""
    echo "[+] ✓ Redroid A9 ready (idle ~270 MB)"
    echo ""
    echo "    Next steps:"
    echo "    - Cài Roblox + disable Settings: ./install-roblox.sh"
    echo "    - Status:                         ./status.sh"
    echo "    - Stop:                           ./stop.sh"
else
    echo "[!] Boot chưa hoàn tất sau 90s"
    echo "    Check: adb -s localhost:5557 shell getprop sys.boot_completed"
fi
