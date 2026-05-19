# Redroid Android 9 Lite - For Roblox
FROM redroid/redroid:9.0.0-latest

# Copy strip script vào /tmp
COPY strip.sh /tmp/strip.sh

# Run strip via sh (Android base không có bash)
RUN sh /tmp/strip.sh && rm /tmp/strip.sh

# Labels
LABEL maintainer="HaHung12"
LABEL description="Redroid Android 9 lite for Roblox login + screencap"
LABEL version="9-lite"
