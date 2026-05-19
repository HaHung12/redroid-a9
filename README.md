# Redroid Android 9 Lite

Android 9 container siêu nhẹ cho Roblox login + screencap. **Idle 170 MB**, Roblox runtime 937 MB.

## 🚀 Memory Benchmark

| Stage | RAM | Note |
|---|---|---|
| Container mới boot | ~460 MB | fresh |
| Sau `./start.sh` (auto optimize.sh) | **~264 MB** | bloat removed |
| Sau `./install-roblox.sh` disable Settings | **~170 MB** | trước launch Roblox |
| Với Roblox running | **~937 MB** | engine ~880 MB |

Variance giữa 4 lần test: ±5%. Deterministic.

## 📋 Yêu cầu hệ thống

- Linux (Ubuntu 22.04+)
- Docker + docker-compose v2
- GPU host mode: `/dev/dri/renderD128`
- Binderfs: `/dev/binderfs`
- ADB: `sudo apt install adb`

## 🏁 Quick Start

```bash
# 1. Clone repo
git clone https://github.com/HaHung12/redroid-a9-lite.git
cd redroid-a9-lite

# 2. Build image (3-5 phút)
cp scripts/strip.sh build/
docker build -t redroid-lite:9 build/

# 3. Đặt Roblox APK vào roblox-apks/
# (Xem roblox-apks/README.md để biết cách tải)
cp /path/to/roblox.apk roblox-apks/roblox.apk

# 4. Start + auto-optimize
./start.sh

# 5. Cài Roblox + launch
./install-roblox.sh
```

## 📜 Scripts

| Script | Mục đích |
|---|---|
| `./start.sh` | Boot container + auto `./optimize.sh` |
| `./optimize.sh` | Disable bloat packages + stop init services + animations off |
| `./install-roblox.sh` | Cài Roblox + disable Settings + launch |
| `./stop.sh` | Stop container |
| `./status.sh` | Check status + memory |

## 🔧 Cấu hình kỹ thuật

### Strip ở build time (image build)
- 33 apps từ `/system/app` (Bluetooth, Camera, Calendar, Email, ...)
- 23 priv-apps từ `/system/priv-app`
- **SystemUI** (verified safe trên A9)
- **Telecom + TeleService**
- Fonts CJK, Noto Serif, Source Sans
- Audio alarms/notifications/ringtones
- bootanimation.zip

### Disable runtime (optimize.sh)
- `android.ext.services`
- `com.android.providers.media`
- `com.android.providers.downloads.ui`
- `com.android.providers.telephony`
- `com.android.provision`

Stop init services: statsd, incidentd, traced, tombstoned, cameraserver, drmserver, mdnsd, ril-daemon

Animations: window_animation_scale=0, transition=0, animator=0

### Disable runtime (install-roblox.sh - SAU khi cài Roblox)
- `com.android.settings`
- `com.android.settings.intelligence`

## ⚠️ Lưu ý quan trọng

1. **KHÔNG disable Settings TRƯỚC khi cài Roblox** — Package Manager mất khả năng index activities → Roblox không launch được. Workflow đã đảm bảo thứ tự đúng.

2. **Roblox engine cố định ~880 MB** — không cách nào tối ưu dưới 937 MB khi Roblox đang chạy. Đây là code của Roblox Corp, không sửa được.

3. **GPU host mode bắt buộc** — cần `/dev/dri/renderD128` mounted.

4. **Port: 5557** (`adb connect localhost:5557`).

## 📊 Lịch sử phát triển

Project follow-up của [redroid-lite-v5](https://github.com/HaHung12/redroid-lite-v5) (Android 13, idle 338 MB).

A9 đạt **idle 150-180 MB** — thấp hơn v5 nhờ strip aggressive thêm SystemUI + disable Settings runtime.

### Các phase test

| Phase | Strip thêm | Idle | Roblox | Status |
|---|---|---|---|---|
| 1.1 | Apps cá nhân | 561 MB | 1.332 GB | ✓ |
| 2 | + SystemUI | 395 MB | 1.013 GB | ✓ |
| 3 | + Telecom + TeleService | 372 MB | 1.058 GB | ✓ |
| 4 (image cuối) | + Phone (folder không có) | 371 MB | 1.058 GB | ✓ |
| 5 | + Strip Settings KHỎI image | 202 MB | ❌ Roblox crash | FAIL |
| **Final** | Phase 4 image + disable Settings RUNTIME | **170 MB** | **937 MB** | ✅ |

## 📈 So sánh A9 vs v5 (Android 13)

| Metric | v5 (A13) | A9 lite | Winner |
|---|---|---|---|
| Idle baseline | 440 MB | 460 MB | v5 |
| **Idle sau optimize** | 338 MB | **170 MB** | **A9** ⭐ |
| Với Roblox | **830 MB** | 937 MB | **v5** ⭐ |
| Image size | 668 MB | 737 MB | v5 |

A9 thắng ở idle (-50% so với v5). v5 thắng với Roblox running (-100 MB so với A9).

## 📝 License

MIT
