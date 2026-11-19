# JuiceBar for macOS 🔋🍎

Battery levels of your wireless **mouse, keyboard, headset, and controller**, right in the **macOS Menu Bar** — each in its maker's iconic color: **Razer** green, **Logitech** blue, **Jabra** amber, **SteelSeries** orange, **Corsair** yellow, **PlayStation** blue, and 10+ more brands.

![JuiceBar for macOS Menu Bar Preview](docs/preview.png)

Inspired by [JuiceBar for Windows](https://github.com/maciejmyron-cloud/juicebar) and [Wireless Battery](https://github.com/krisgfx9/Wireless-Device-Battery-Monitor), rewritten from scratch as a **100% native, single-file Swift/AppKit macOS application** (`src/main.swift`) with zero external dependencies and zero network access.

---

## ✨ Features

- **Brand-Colored Menu Bar Pills:** Displays an SF Symbol icon (`headphones`, `computermouse.fill`, `keyboard.fill`, `gamecontroller.fill`), battery percentage, a soft glow, and a colored progress bar underneath for every connected wireless peripheral.
- **Multi-Source Battery Detection:**
  1. **macOS Power Management (`pmset -g accps`):** Captures Bluetooth Classic, Bluetooth Low Energy (BLE HID), Jabra headsets, Razer mice/keyboards, custom mechanical keyboards (ZMK/QMK/Skyfall/Keychron), Apple Magic peripherals, and AirPods.
  2. **IOKit HID Registry (`ioreg`):** Fallback for USB/Bluetooth HID devices exposing `BatteryPercent`.
  3. **HeadsetControl Integration (Optional):** Automatically queries [`headsetcontrol`](https://github.com/Sapd/HeadsetControl) if installed via Homebrew (`brew install headsetcontrol`) to read battery levels from 2.4 GHz USB wireless gaming headsets (Corsair, SteelSeries Arctis, Logitech G PRO X, HyperX Cloud, Razer BlackShark).
- **Smart Sleep Memory:** Sleeping mice or keyboards stay visible (dimmed) with their last known battery percentage instead of disappearing whenever they enter power-saving mode. Can be toggled off in the menu.
- **Friendly Device Naming:** Automatically translates cryptic Bluetooth names (e.g., `PCV2 Ver` → `Razer Pro Click V2 Vertical`, `DSV2 Pro` → `Razer DeathStalker V2 Pro`, strips `LE-` prefixes).
- **Zero Bloat & 100% Offline:** Entire app is a single readable Swift file (~500 lines). Never connects to the internet. Automatically adapts to English and French macOS locales and Dark/Light menu bars.

---

## 🎨 Supported Brands & Colors

| Brand | Color | Recognized Devices |
| :--- | :--- | :--- |
| **Razer** | Green `#44D62C` | DeathAdder, Viper, Basilisk, Pro Click (`PCV2 Ver`), DeathStalker (`DSV2`), BlackWidow, Huntsman, BlackShark, Barracuda |
| **Logitech** | Light Blue `#00B8FC` | MX Master, MX Keys, MX Anywhere, G502, G915, G PRO X, LIGHTSPEED, K380 |
| **Jabra** | Amber `#FFC800` | Jabra Evolve / Evolve2 series, Jabra Link |
| **SteelSeries** | Orange `#FF5200` | Arctis, Aerox, Rival |
| **Corsair** | Yellow `#F5E41A` | HS80, Virtuoso, Corsair wireless mice/keyboards |
| **HyperX** | Red `#E31837` | Cloud III, Cloud Alpha, Pulsefire |
| **ASUS ROG** | Red `#FF0029` | ROG Harpe, Azoth, Keris, Gladius |
| **ZOWIE** | Red `#E2231A` | EC-CW, U2, DW wireless mice |
| **PlayStation** | Blue `#0070D1` | DualSense, DualShock 4, INZONE headsets |
| **Xbox** | Green `#107C10` | Xbox Wireless Controllers & Headsets |
| **Samsung** | Blue `#1428A0` | Galaxy Buds |
| **Apple** | Silver `#D6D9E0` | AirPods, Beats, Magic Mouse, Magic Keyboard, Magic Trackpad |
| **JBL** | Red-Orange `#FF3D00` | JBL Quantum & Bluetooth headphones |
| **Cooler Master** | Purple `#B866FF` | MM712 and Cooler Master wireless gear |
| **Steam** | Blue `#1A9FFF` | Steam Controller |
| **Skyfall** | Cyan `#00D2FF` | Skyfall 80P / custom BLE mechanical keyboards |

---

## 🚀 Installation

### Option 1: Build & Install from Source (10 seconds)
Requires only the macOS Command Line Tools (`swiftc`):

```bash
git clone https://github.com/gwenaelbe1430/JuiceBarMac.git
cd JuiceBarMac
make install
open /Applications/JuiceBar.app
```

### Option 2: Pre-built Release
1. Download `JuiceBar-macOS-universal.zip` from **[Releases](../../releases/latest)**.
2. Unzip and drag **`JuiceBar.app`** to `/Applications`.
3. If macOS Gatekeeper prompts that the app is unsigned, run:
   ```bash
   xattr -cr /Applications/JuiceBar.app
   open /Applications/JuiceBar.app
   ```

---

## 🛠️ Command-Line Options

```bash
# List detected wireless devices and their battery levels in the terminal:
/Applications/JuiceBar.app/Contents/MacOS/JuiceBar --list

# Run with sample devices of multiple brands (for testing or screenshots):
/Applications/JuiceBar.app/Contents/MacOS/JuiceBar --demo

# Generate a PNG preview image of the menu bar widget:
/Applications/JuiceBar.app/Contents/MacOS/JuiceBar --preview docs/preview.png
```

---

## 📜 License & Credits

Licensed under **GNU GPL v3.0 or later**.
- Concept and brand color palette inspired by [JuiceBar for Windows](https://github.com/maciejmyron-cloud/juicebar) by `maciejmyron-cloud` and [Wireless Battery](https://github.com/krisgfx9/Wireless-Device-Battery-Monitor) by `krisgfx9`.
