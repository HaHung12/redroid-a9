#!/bin/bash
echo "=== Container ==="
docker ps -a | grep redroid-a9 || echo "(không có)"

echo ""
echo "=== Memory ==="
docker stats redroid-a9 --no-stream 2>/dev/null | grep redroid || echo "(container chưa chạy)"

echo ""
echo "=== ADB ==="
adb -s localhost:5557 shell getprop sys.boot_completed 2>/dev/null && echo "✓ Booted" || echo "✗ Not booted"
