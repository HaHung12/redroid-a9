#!/bin/sh
# Strip Android 9 - Phase 4 ULTRA RISKY
# Bỏ SystemUI + Telecom + TeleService + Phone khỏi filesystem

set -e

echo "=== Phase 4 ULTRA RISKY Strip ==="
echo "Initial size:"
du -sh /system

# Remove from /system/app
cd /system/app
for app in \
    BasicDreams \
    Bluetooth \
    BluetoothMidiService \
    BookmarkProvider \
    Browser2 \
    BuiltInPrintService \
    Calendar \
    Camera2 \
    CaptivePortalLogin \
    CertInstaller \
    CompanionDeviceManager \
    CtsShimPrebuilt \
    DeskClock \
    EasterEgg \
    Email \
    ExactCalculator \
    Gallery2 \
    HTMLViewer \
    KeyChain \
    LatinIME \
    LiveWallpapersPicker \
    Music \
    NfcNci \
    PacProcessor \
    PhotoTable \
    Phone \
    PrintRecommendationService \
    PrintSpooler \
    QuickSearchBox \
    SecureElement \
    SimAppDialog \
    Traceur \
    WAPPushManager \
    WallpaperBackup
do
    [ -d "$app" ] && rm -rf "$app" && echo "  Removed app/$app"
done

# Remove from /system/priv-app
cd /system/priv-app
for app in \
    BackupRestoreConfirmation \
    BlockedNumberProvider \
    CalendarProvider \
    Contacts \
    ContactsProvider \
    CtsShimPrivPrebuilt \
    FusedLocation \
    Launcher3QuickStep \
    ManagedProvisioning \
    MmsService \
    MtpDocumentsProvider \
    MusicFX \
    OneTimeInitializer \
    Phone \
    ProxyHandler \
    SharedStorageBackup \
    StatementService \
    SystemUI \
    TeleService \
    Telecom \
    UserDictionaryProvider \
    VpnDialogs \
    WallpaperCropper
do
    [ -d "$app" ] && rm -rf "$app" && echo "  Removed priv-app/$app"
done

# Fonts
cd /system/fonts
rm -f NotoColorEmoji.ttf NotoSansCJK*.otf NotoSerif*.ttf SourceSansPro*.ttf 2>/dev/null

# Media
rm -rf /system/media/audio/alarms 2>/dev/null && echo "  Removed audio/alarms"
rm -rf /system/media/audio/notifications 2>/dev/null && echo "  Removed audio/notifications"
rm -rf /system/media/audio/ringtones 2>/dev/null && echo "  Removed audio/ringtones"
rm -f /system/media/bootanimation.zip 2>/dev/null && echo "  Removed bootanimation"

echo ""
echo "=== Strip done ==="
echo "Final size:"
du -sh /system
