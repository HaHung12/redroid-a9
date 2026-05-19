#!/bin/bash
# Auto-optimize A9 sau khi container boot
# Target: idle ~250-300 MB

PORT=5557

echo "=== Memory before ==="
docker stats redroid-a9 --no-stream | grep redroid-a9

echo ""
echo "=== Skip provision ==="
adb -s localhost:$PORT shell settings put global device_provisioned 1
adb -s localhost:$PORT shell settings put secure user_setup_complete 1

echo ""
echo "=== Disable bloat packages ==="
for pkg in \
    android.ext.services \
    com.android.providers.media \
    com.android.providers.downloads.ui \
    com.android.providers.telephony \
    com.android.provision
do
    adb -s localhost:$PORT shell pm disable-user $pkg 2>&1 | grep -q "new state" && echo "  ✓ $pkg" || true
done

echo ""
echo "=== Animations OFF ==="
adb -s localhost:$PORT shell settings put global window_animation_scale 0
adb -s localhost:$PORT shell settings put global transition_animation_scale 0
adb -s localhost:$PORT shell settings put global animator_duration_scale 0

echo ""
echo "=== Stop init services ==="
for svc in statsd incidentd traced traced_probes tombstoned cameraserver drmserver mdnsd ril-daemon; do
    adb -s localhost:$PORT shell setprop ctl.stop $svc 2>/dev/null
done

echo ""
echo "=== Force stop idle ==="
for proc in com.android.provision android.process.media com.android.packageinstaller android.ext.services com.android.defcontainer; do
    adb -s localhost:$PORT shell am force-stop $proc 2>/dev/null
done

# Kill all idle
adb -s localhost:$PORT shell am kill-all

# Drop caches
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
sleep 5

echo ""
echo "=== Memory IDLE ==="
docker stats redroid-a9 --no-stream | grep redroid-a9

echo ""
echo "✓ Optimize done. Cài Roblox: adb -s localhost:$PORT install ROBLOX.apk"
echo "  Sau cài, để disable Settings (TIẾT KIỆM 228 MB):"
echo "  adb -s localhost:$PORT shell pm disable-user com.android.settings"
