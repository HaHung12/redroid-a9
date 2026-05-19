#!/bin/bash
# Cài Roblox + disable Settings (sau khi cài để giảm RAM tối đa)

PORT=5557
APK="${1:-$HOME/redroid-lite/roblox-apks/roblox.apk}"

echo "=== Cài Roblox từ $APK ==="
adb -s localhost:$PORT install "$APK"

echo ""
echo "=== Grant permissions ==="
adb -s localhost:$PORT shell pm grant com.roblox.client android.permission.RECORD_AUDIO
adb -s localhost:$PORT shell pm grant com.roblox.client android.permission.CAMERA

echo ""
echo "=== Disable Settings (sau khi đã cài) ==="
adb -s localhost:$PORT shell pm disable-user com.android.settings
adb -s localhost:$PORT shell pm disable-user com.android.settings.intelligence 2>/dev/null
adb -s localhost:$PORT shell am force-stop com.android.settings

sleep 3

echo ""
echo "=== Memory sau disable Settings ==="
docker stats redroid-a9 --no-stream | grep redroid-a9

echo ""
echo "=== Launch Roblox ==="
adb -s localhost:$PORT shell am start -n com.roblox.client/.startup.ActivitySplash

echo "Đợi 30s..."
sleep 30

echo ""
echo "=== Memory với Roblox ==="
docker stats redroid-a9 --no-stream | grep redroid-a9

echo ""
echo "=== Roblox alive? ==="
adb -s localhost:$PORT shell "ps -A | grep roblox"
