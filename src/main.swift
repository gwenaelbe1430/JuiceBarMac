// JuiceBar for macOS — Wireless Mouse, Keyboard, Headset & Controller Battery Levels in the macOS Menu Bar
// Inspired by JuiceBar (https://github.com/maciejmyron-cloud/juicebar) & Wireless Battery (https://github.com/krisgfx9/Wireless-Device-Battery-Monitor)
// License: GNU GPL v3.0 or later

import Cocoa

// MARK: - Localization Helper (Auto FR / EN)

let isFrenchLocale: Bool = {
    let lang = Locale.preferredLanguages.first ?? "en"
    return lang.lowercased().hasPrefix("fr")
}()

func L(_ en: String, _ fr: String) -> String {
    return isFrenchLocale ? fr : en
}

// MARK: - Data Models & Brand Colors

enum DeviceKind: Int {
    case headset = 0
    case mouse = 1
    case keyboard = 2
    case gamepad = 3
    case phone = 4
    case other = 5

    var sfSymbol: String {
        switch self {
        case .headset:  return "headphones"
        case .mouse:    return "computermouse.fill"
        case .keyboard: return "keyboard.fill"
        case .gamepad:  return "gamecontroller.fill"
        case .phone:    return "iphone"
        case .other:    return "bolt.horizontal.circle.fill"
        }
    }

    var label: String {
        switch self {
        case .headset:  return L("Headset", "Casque")
        case .mouse:    return L("Mouse", "Souris")
        case .keyboard: return L("Keyboard", "Clavier")
        case .gamepad:  return L("Controller", "Manette")
        case .phone:    return L("Phone", "Téléphone")
        case .other:    return L("Device", "Périphérique")
        }
    }
}

enum BrandAccent: String, CaseIterable {
    case razer = "Razer"
    case logitech = "Logitech"
    case steelseries = "SteelSeries"
    case corsair = "Corsair"
    case hyperx = "HyperX"
    case rog = "ASUS ROG"
    case zowie = "ZOWIE"
    case playstation = "PlayStation"
    case xbox = "Xbox"
    case samsung = "Samsung"
    case apple = "Apple"
    case jabra = "Jabra"
    case jbl = "JBL"
    case coolermaster = "Cooler Master"
    case steam = "Steam"
    case skyfall = "Skyfall"
    case generic = "Generic"

    func color(forDarkMenu isDark: Bool) -> NSColor {
        switch self {
        case .razer:
            return isDark ? NSColor(srgbRed: 0x44/255.0, green: 0xD6/255.0, blue: 0x2C/255.0, alpha: 1) : NSColor(srgbRed: 0x1E/255.0, green: 0x8E/255.0, blue: 0x10/255.0, alpha: 1)
        case .logitech:
            return isDark ? NSColor(srgbRed: 0x00/255.0, green: 0xB8/255.0, blue: 0xFC/255.0, alpha: 1) : NSColor(srgbRed: 0x00/255.0, green: 0x7A/255.0, blue: 0xB8/255.0, alpha: 1)
        case .steelseries:
            return NSColor(srgbRed: 0xFF/255.0, green: 0x52/255.0, blue: 0x00/255.0, alpha: 1)
        case .corsair:
            return isDark ? NSColor(srgbRed: 0xF5/255.0, green: 0xE4/255.0, blue: 0x1A/255.0, alpha: 1) : NSColor(srgbRed: 0xB8/255.0, green: 0x86/255.0, blue: 0x00/255.0, alpha: 1)
        case .hyperx:
            return NSColor(srgbRed: 0xE3/255.0, green: 0x18/255.0, blue: 0x37/255.0, alpha: 1)
        case .rog:
            return NSColor(srgbRed: 0xFF/255.0, green: 0x00/255.0, blue: 0x29/255.0, alpha: 1)
        case .zowie:
            return NSColor(srgbRed: 0xE2/255.0, green: 0x23/255.0, blue: 0x1A/255.0, alpha: 1)
        case .playstation:
            return isDark ? NSColor(srgbRed: 0x2E/255.0, green: 0x9A/255.0, blue: 0xFF/255.0, alpha: 1) : NSColor(srgbRed: 0x00/255.0, green: 0x70/255.0, blue: 0xD1/255.0, alpha: 1)
        case .xbox:
            return isDark ? NSColor(srgbRed: 0x2A/255.0, green: 0xB8/255.0, blue: 0x2A/255.0, alpha: 1) : NSColor(srgbRed: 0x10/255.0, green: 0x7C/255.0, blue: 0x10/255.0, alpha: 1)
        case .samsung:
            return isDark ? NSColor(srgbRed: 0x4E/255.0, green: 0x7D/255.0, blue: 0xFF/255.0, alpha: 1) : NSColor(srgbRed: 0x14/255.0, green: 0x28/255.0, blue: 0xA0/255.0, alpha: 1)
        case .apple:
            return isDark ? NSColor(srgbRed: 0xD6/255.0, green: 0xD9/255.0, blue: 0xE0/255.0, alpha: 1) : NSColor(srgbRed: 0x55/255.0, green: 0x58/255.0, blue: 0x60/255.0, alpha: 1)
        case .jabra:
            return isDark ? NSColor(srgbRed: 0xFF/255.0, green: 0xC8/255.0, blue: 0x00/255.0, alpha: 1) : NSColor(srgbRed: 0xC8/255.0, green: 0x8A/255.0, blue: 0x00/255.0, alpha: 1)
        case .jbl:
            return NSColor(srgbRed: 0xFF/255.0, green: 0x3D/255.0, blue: 0x00/255.0, alpha: 1)
        case .coolermaster:
            return isDark ? NSColor(srgbRed: 0xB8/255.0, green: 0x66/255.0, blue: 0xFF/255.0, alpha: 1) : NSColor(srgbRed: 0x7B/255.0, green: 0x2C/255.0, blue: 0xBF/255.0, alpha: 1)
        case .steam:
            return NSColor(srgbRed: 0x1A/255.0, green: 0x9F/255.0, blue: 0xFF/255.0, alpha: 1)
        case .skyfall:
            return isDark ? NSColor(srgbRed: 0x00/255.0, green: 0xD2/255.0, blue: 0xFF/255.0, alpha: 1) : NSColor(srgbRed: 0x00/255.0, green: 0x7A/255.0, blue: 0xCC/255.0, alpha: 1)
        case .generic:
            return isDark ? NSColor(srgbRed: 0x1E/255.0, green: 0xBE/255.0, blue: 0x5A/255.0, alpha: 1) : NSColor(srgbRed: 0x14/255.0, green: 0x8A/255.0, blue: 0x40/255.0, alpha: 1)
        }
    }
}

struct DeviceBattery {
    var rawName: String
    var displayName: String
    var percent: Int
    var charging: Bool
    var kind: DeviceKind
    var brand: BrandAccent
    var asleep: Bool
}

// MARK: - Device Detection & Classification

class BatteryMonitor {
    private var lastKnown: [String: DeviceBattery] = [:]
    private let defaults = UserDefaults.standard
    var demoMode: Bool = false

    init() {
        if let saved = defaults.dictionary(forKey: "LastKnownBatteries") as? [String: Int] {
            for (rawName, pct) in saved {
                var dev = classify(rawName: rawName, percent: pct, charging: false)
                dev.asleep = true
                lastKnown[rawName] = dev
            }
        }
    }

    func classify(rawName: String, percent: Int, charging: Bool, forcedKind: DeviceKind? = nil) -> DeviceBattery {
        var display = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        for prefix in ["LE-", "LE_"] {
            if display.hasPrefix(prefix) && display.count > 3 {
                display = String(display.dropFirst(3))
            }
        }

        let friendlyMap: [String: String] = [
            "PCV2 Ver": "Razer Pro Click V2 Vertical",
            "DSV2 Pro": "Razer DeathStalker V2 Pro",
            "DSV2": "Razer DeathStalker V2",
            "DSV2 Pro TKL": "Razer DeathStalker V2 Pro TKL",
            "SKYFALL80P BT5.0 KB2": "Skyfall 80P Keyboard"
        ]
        if let mapped = friendlyMap[display] {
            display = mapped
        }

        let lower = (rawName + " " + display).lowercased()

        let brand: BrandAccent
        if lower.contains("razer") || lower.contains("pcv2") || lower.contains("deathadder") || lower.contains("viper") || lower.contains("basilisk") || lower.contains("deathstalker") || lower.contains("blackwidow") || lower.contains("huntsman") || lower.contains("orochi") || lower.contains("naga") || lower.contains("blackshark") || lower.contains("barracuda") {
            brand = .razer
        } else if lower.contains("jabra") || lower.contains("evolve") {
            brand = .jabra
        } else if lower.contains("skyfall") {
            brand = .skyfall
        } else if lower.contains("logitech") || lower.contains("logi") || lower.contains("mx ") || lower.contains("g502") || lower.contains("g915") || lower.contains("g pro") || lower.contains("lightspeed") || lower.contains("k380") {
            brand = .logitech
        } else if lower.contains("steelseries") || lower.contains("arctis") || lower.contains("aerox") || lower.contains("rival") {
            brand = .steelseries
        } else if lower.contains("corsair") || lower.contains("hs80") || lower.contains("virtuoso") {
            brand = .corsair
        } else if lower.contains("hyperx") || lower.contains("pulsefire") || lower.contains("cloud iii") || lower.contains("cloud alpha") {
            brand = .hyperx
        } else if lower.contains("rog ") || lower.contains("asus") {
            brand = .rog
        } else if lower.contains("zowie") {
            brand = .zowie
        } else if lower.contains("dualsense") || lower.contains("dualshock") || lower.contains("inzone") || lower.contains("playstation") {
            brand = .playstation
        } else if lower.contains("xbox") {
            brand = .xbox
        } else if lower.contains("galaxy") || lower.contains("samsung") {
            brand = .samsung
        } else if lower.contains("airpods") || lower.contains("magic mouse") || lower.contains("magic keyboard") || lower.contains("magic trackpad") || lower.contains("beats") {
            brand = .apple
        } else if lower.contains("jbl") || lower.contains("quantum") {
            brand = .jbl
        } else if lower.contains("cooler master") || lower.contains("mm712") {
            brand = .coolermaster
        } else if lower.contains("steam") {
            brand = .steam
        } else {
            brand = .generic
        }

        let kind: DeviceKind
        if let fk = forcedKind {
            kind = fk
        } else if lower.contains("evolve") || lower.contains("jabra") || lower.contains("headset") || lower.contains("headphone") || lower.contains("airpods") || lower.contains("buds") || lower.contains("arctis") || lower.contains("blackshark") || lower.contains("barracuda") || lower.contains("cloud") || lower.contains("quantum") || lower.contains("hs80") || lower.contains("inzone") || lower.contains("virtuoso") {
            kind = .headset
        } else if lower.contains("pcv2") || lower.contains("mouse") || lower.contains("trackpad") || lower.contains("pro click") || lower.contains("deathadder") || lower.contains("viper") || lower.contains("basilisk") || lower.contains("naga") || lower.contains("orochi") || lower.contains("g502") || lower.contains("mx master") || lower.contains("mx anywhere") || lower.contains("aerox") || lower.contains("harpe") || lower.contains("ec2") || lower.contains("pulsefire") || lower.contains("mm712") {
            kind = .mouse
        } else if lower.contains("kb") || lower.contains("keyboard") || lower.contains("skyfall") || lower.contains("keychron") || lower.contains("deathstalker") || lower.contains("blackwidow") || lower.contains("huntsman") || lower.contains("g915") || lower.contains("k380") || lower.contains("mx keys") {
            kind = .keyboard
        } else if lower.contains("controller") || lower.contains("dualsense") || lower.contains("dualshock") || lower.contains("xbox") || lower.contains("gamepad") {
            kind = .gamepad
        } else {
            kind = .other
        }

        return DeviceBattery(
            rawName: rawName,
            displayName: display,
            percent: percent,
            charging: charging,
            kind: kind,
            brand: brand,
            asleep: false
        )
    }

    func demoDevices() -> [DeviceBattery] {
        return [
            classify(rawName: "Jabra Evolve2 65", percent: 60, charging: false, forcedKind: .headset),
            classify(rawName: "PCV2 Ver", percent: 34, charging: false, forcedKind: .mouse),
            classify(rawName: "SKYFALL80P BT5.0 KB2", percent: 75, charging: false, forcedKind: .keyboard),
            classify(rawName: "Logitech G PRO X 2 LIGHTSPEED", percent: 88, charging: true, forcedKind: .headset),
            classify(rawName: "DualSense Wireless Controller", percent: 14, charging: false, forcedKind: .gamepad)
        ]
    }

    func poll(keepSleeping: Bool) -> [DeviceBattery] {
        if demoMode { return demoDevices() }
        var found: [String: DeviceBattery] = [:]

        // 1. Poll via `pmset -g accps` (Bluetooth Classic, BLE HID, Magic devices, Jabra, Razer, Keyboards...)
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        proc.arguments = ["-g", "accps"]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = FileHandle.nullDevice

        do {
            try proc.run()
            proc.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                for line in output.components(separatedBy: .newlines) {
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    guard trimmed.hasPrefix("-") else { continue }
                    if trimmed.contains("InternalBattery-") { continue }

                    guard let idRange = trimmed.range(of: " (id=") else { continue }
                    let rawName = String(trimmed[trimmed.index(after: trimmed.startIndex)..<idRange.lowerBound]).trimmingCharacters(in: .whitespaces)

                    let afterId = String(trimmed[idRange.upperBound...])
                    guard let pctMatch = afterId.range(of: #"\d+%"#, options: .regularExpression) else { continue }
                    let pctStr = afterId[pctMatch].dropLast()
                    guard let pct = Int(pctStr) else { continue }

                    let lowerRest = afterId.lowercased()
                    let isCharging = (lowerRest.contains("charging") && !lowerRest.contains("discharging") && !lowerRest.contains("not charging")) || lowerRest.contains("charged")

                    let dev = classify(rawName: rawName, percent: pct, charging: isCharging)
                    found[rawName] = dev
                    lastKnown[rawName] = dev
                }
            }
        } catch {}

        // 2. Fallback: Check `ioreg -r -k BatteryPercent` for USB/HID devices not listed in `pmset -g accps`
        let ioProc = Process()
        ioProc.executableURL = URL(fileURLWithPath: "/usr/sbin/ioreg")
        ioProc.arguments = ["-r", "-k", "BatteryPercent", "-l"]
        let ioPipe = Pipe()
        ioProc.standardOutput = ioPipe
        ioProc.standardError = FileHandle.nullDevice

        do {
            try ioProc.run()
            ioProc.waitUntilExit()
            let data = ioPipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                var currentProduct: String?
                for line in output.components(separatedBy: .newlines) {
                    if let prodRange = line.range(of: #""Product"\s*=\s*"([^"]+)""#, options: .regularExpression) {
                        let sub = String(line[prodRange])
                        if let firstQuote = sub.firstIndex(of: "\""),
                           let afterKey = sub[sub.index(after: firstQuote)...].firstIndex(of: "\""),
                           let valStart = sub[sub.index(after: afterKey)...].firstIndex(of: "\"") {
                            let rest = sub[sub.index(after: valStart)...]
                            if let valEnd = rest.firstIndex(of: "\"") {
                                currentProduct = String(rest[..<valEnd])
                            }
                        }
                    } else if let pctRange = line.range(of: #""BatteryPercent"\s*=\s*(\d+)"#, options: .regularExpression),
                              let prod = currentProduct {
                        let sub = String(line[pctRange])
                        if let numMatch = sub.range(of: #"\d+$"#, options: .regularExpression),
                           let pct = Int(sub[numMatch]),
                           found[prod] == nil {
                            let dev = classify(rawName: prod, percent: pct, charging: false)
                            found[prod] = dev
                            lastKnown[prod] = dev
                        }
                    }
                }
            }
        } catch {}

        // 3. Optional: Check `headsetcontrol` if installed via Homebrew (supports 2.4GHz USB wireless headsets)
        for hscPath in ["/opt/homebrew/bin/headsetcontrol", "/usr/local/bin/headsetcontrol"] {
            if FileManager.default.isExecutableFile(atPath: hscPath) {
                let hscProc = Process()
                hscProc.executableURL = URL(fileURLWithPath: hscPath)
                hscProc.arguments = ["-o", "json"]
                let hscPipe = Pipe()
                hscProc.standardOutput = hscPipe
                hscProc.standardError = FileHandle.nullDevice
                do {
                    try hscProc.run()
                    hscProc.waitUntilExit()
                    let data = hscPipe.fileHandleForReading.readDataToEndOfFile()
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let devices = json["devices"] as? [[String: Any]] {
                        for d in devices {
                            guard let name = d["device"] as? String,
                                  let bat = d["battery"] as? [String: Any],
                                  let status = bat["status"] as? String,
                                  status != "BATTERY_UNAVAILABLE",
                                  let level = bat["level"] as? Int, level >= 0 else { continue }
                            if found[name] == nil {
                                let charging = (status == "BATTERY_CHARGING")
                                let dev = classify(rawName: name, percent: level, charging: charging, forcedKind: .headset)
                                found[name] = dev
                                lastKnown[name] = dev
                            }
                        }
                    }
                } catch {}
                break
            }
        }

        // Save last known levels
        var toSave: [String: Int] = [:]
        for (k, v) in lastKnown { toSave[k] = v.percent }
        defaults.set(toSave, forKey: "LastKnownBatteries")

        var result: [DeviceBattery] = Array(found.values)
        if keepSleeping {
            for (k, var v) in lastKnown where found[k] == nil {
                v.asleep = true
                result.append(v)
            }
        }

        result.sort { a, b in
            if a.kind.rawValue != b.kind.rawValue {
                return a.kind.rawValue < b.kind.rawValue
            }
            return a.displayName < b.displayName
        }
        return result
    }
}

// MARK: - Menu Bar Renderer (JuiceBar Style)

func renderStatusBarImage(visibleDevices: [DeviceBattery], isDark: Bool) -> NSImage {
    let height: CGFloat = 22.0

    if visibleDevices.isEmpty {
        let width: CGFloat = 34.0
        let img = NSImage(size: NSSize(width: width, height: height), flipped: false) { _ in
            if let sym = NSImage(systemSymbolName: "battery.100.bolt", accessibilityDescription: "JuiceBar") {
                let cfg = NSImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
                let configured = sym.withSymbolConfiguration(cfg) ?? sym
                configured.draw(in: NSRect(x: 6, y: 4, width: 22, height: 14))
            }
            return true
        }
        img.isTemplate = true
        return img
    }

    struct LayoutItem {
        let dev: DeviceBattery
        let textAttr: NSAttributedString
        let textSize: NSSize
        let itemWidth: CGFloat
        let brandColor: NSColor
    }

    let font = NSFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .bold)
    let iconSize: CGFloat = 13.5
    let iconTextSpacing: CGFloat = 3.5
    let itemSpacing: CGFloat = 10.0
    let horizontalPad: CGFloat = 4.0

    var layoutItems: [LayoutItem] = []
    var totalWidth: CGFloat = horizontalPad * 2

    for (idx, dev) in visibleDevices.enumerated() {
        let bColor = dev.brand.color(forDarkMenu: isDark)
        let isLow = !dev.charging && dev.percent <= 15
        let alpha: CGFloat = dev.asleep ? 0.48 : 1.0

        let textColor: NSColor
        if isLow {
            textColor = NSColor(srgbRed: 0.95, green: 0.22, blue: 0.26, alpha: alpha)
        } else if dev.charging {
            textColor = NSColor(srgbRed: 0.0, green: 0.72, blue: 1.0, alpha: alpha)
        } else {
            textColor = (isDark ? NSColor.white : NSColor.black).withAlphaComponent(alpha)
        }

        let labelText = dev.charging ? "\(dev.percent)%⚡" : "\(dev.percent)%"
        let attr = NSAttributedString(string: labelText, attributes: [
            .font: font,
            .foregroundColor: textColor
        ])
        let tSize = attr.size()
        let iWidth = iconSize + iconTextSpacing + ceil(tSize.width) + 2.0
        layoutItems.append(LayoutItem(dev: dev, textAttr: attr, textSize: tSize, itemWidth: iWidth, brandColor: bColor.withAlphaComponent(alpha)))
        totalWidth += iWidth
        if idx < visibleDevices.count - 1 {
            totalWidth += itemSpacing
        }
    }

    let image = NSImage(size: NSSize(width: totalWidth, height: height), flipped: false) { _ in
        var x = horizontalPad

        for item in layoutItems {
            let dev = item.dev
            let alpha: CGFloat = dev.asleep ? 0.48 : 1.0
            let isLow = !dev.charging && dev.percent <= 15
            let barColor: NSColor = dev.charging
                ? NSColor(srgbRed: 0.0, green: 0.68, blue: 1.0, alpha: alpha)
                : (isLow ? NSColor(srgbRed: 0.92, green: 0.15, blue: 0.20, alpha: alpha) : item.brandColor)

            // 1. Soft brand glow behind the item
            let glowRect = NSRect(x: x - 2, y: 2, width: item.itemWidth + 4, height: height - 4)
            let glowPath = NSBezierPath(roundedRect: glowRect, xRadius: 4, yRadius: 4)
            item.brandColor.withAlphaComponent(dev.asleep ? 0.06 : 0.14).setFill()
            glowPath.fill()

            // 2. SF Symbol Icon tinted with brand color
            if let baseSym = NSImage(systemSymbolName: dev.kind.sfSymbol, accessibilityDescription: dev.displayName) {
                let symCfg = NSImage.SymbolConfiguration(pointSize: 11.5, weight: .semibold)
                let sym = baseSym.withSymbolConfiguration(symCfg) ?? baseSym
                let tinted = NSImage(size: sym.size, flipped: false) { sRect in
                    sym.draw(in: sRect)
                    item.brandColor.set()
                    sRect.fill(using: .sourceAtop)
                    return true
                }
                let iconY = (height - iconSize) / 2.0 + 1.5
                tinted.draw(in: NSRect(x: x, y: iconY, width: iconSize, height: iconSize))
            }

            // 3. Percentage text
            let textX = x + iconSize + iconTextSpacing
            let textY = (height - item.textSize.height) / 2.0 + 1.5
            item.textAttr.draw(at: NSPoint(x: textX, y: textY))

            // 4. JuiceBar level bar underneath (track + filled bar)
            let barY: CGFloat = 2.0
            let barH: CGFloat = 2.5
            let barW: CGFloat = item.itemWidth
            let trackRect = NSRect(x: x, y: barY, width: barW, height: barH)
            let trackPath = NSBezierPath(roundedRect: trackRect, xRadius: 1.25, yRadius: 1.25)
            (isDark ? NSColor.white : NSColor.black).withAlphaComponent(0.20).setFill()
            trackPath.fill()

            let clampedPct = max(0, min(100, dev.percent))
            if clampedPct > 0 {
                let fillW = max(3.0, barW * CGFloat(clampedPct) / 100.0)
                let fillRect = NSRect(x: x, y: barY, width: fillW, height: barH)
                let fillPath = NSBezierPath(roundedRect: fillRect, xRadius: 1.25, yRadius: 1.25)
                barColor.setFill()
                fillPath.fill()
            }

            x += item.itemWidth + itemSpacing
        }
        return true
    }

    image.isTemplate = false
    return image
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    let monitor = BatteryMonitor()
    var timer: Timer?
    var devices: [DeviceBattery] = []
    var hiddenDevices: Set<String> = []
    var hideSleeping: Bool = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let savedHidden = UserDefaults.standard.stringArray(forKey: "HiddenDevices") {
            hiddenDevices = Set(savedHidden)
        }
        hideSleeping = UserDefaults.standard.bool(forKey: "HideSleeping")

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.imagePosition = .imageOnly
        }

        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    @objc func refresh() {
        devices = monitor.poll(keepSleeping: true)
        updateStatusBar()
        rebuildMenu()
    }

    func isVisible(_ dev: DeviceBattery) -> Bool {
        if hiddenDevices.contains(dev.rawName) { return false }
        if hideSleeping && dev.asleep { return false }
        return true
    }

    func updateStatusBar() {
        guard let button = statusItem.button else { return }
        let visible = devices.filter { isVisible($0) }
        let isDark = button.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        button.image = renderStatusBarImage(visibleDevices: visible, isDark: isDark)

        if visible.isEmpty {
            button.toolTip = L("JuiceBar: No devices displayed", "JuiceBar : Aucun périphérique affiché")
        } else {
            button.toolTip = visible.map { d in
                var st = "\(d.displayName) (\(d.brand.rawValue)): \(d.percent)%"
                if d.charging { st += L(" (charging)", " (en charge)") }
                if d.asleep { st += L(" (asleep / last known)", " (en veille / dernier état connu)") }
                return st
            }.joined(separator: "\n")
        }
    }

    func rebuildMenu() {
        let menu = NSMenu()

        let headerItem = NSMenuItem(
            title: L("JuiceBar — Wireless Batteries", "JuiceBar — Batteries sans fil"),
            action: nil,
            keyEquivalent: ""
        )
        headerItem.isEnabled = false
        menu.addItem(headerItem)
        menu.addItem(NSMenuItem.separator())

        if devices.isEmpty {
            let empty = NSMenuItem(
                title: L("No wireless devices with battery info found", "Aucun périphérique détecté"),
                action: nil,
                keyEquivalent: ""
            )
            empty.isEnabled = false
            menu.addItem(empty)
        } else {
            let hint = NSMenuItem(
                title: L("Click a device to show or hide it:", "Cliquer sur un appareil pour l'afficher / masquer :"),
                action: nil,
                keyEquivalent: ""
            )
            hint.isEnabled = false
            menu.addItem(hint)

            for (idx, dev) in devices.enumerated() {
                var statusStr = "\(dev.percent)%"
                if dev.charging { statusStr += L(" ⚡ Charging", " ⚡ En charge") }
                if dev.asleep { statusStr += L(" 💤 Asleep (last known)", " 💤 En veille (dernier connu)") }

                let title = "\(dev.displayName)  —  \(statusStr)   [\(dev.brand.rawValue)]"
                let item = NSMenuItem(title: title, action: #selector(toggleDevice(_:)), keyEquivalent: "")
                item.target = self
                item.tag = idx
                item.state = hiddenDevices.contains(dev.rawName) ? .off : .on
                if let sym = NSImage(systemSymbolName: dev.kind.sfSymbol, accessibilityDescription: dev.kind.label) {
                    item.image = sym
                }
                menu.addItem(item)
            }
        }

        menu.addItem(NSMenuItem.separator())

        let hideSleepItem = NSMenuItem(
            title: L("Hide asleep / last known devices", "Masquer les appareils éteints / en veille"),
            action: #selector(toggleHideSleeping),
            keyEquivalent: ""
        )
        hideSleepItem.target = self
        hideSleepItem.state = hideSleeping ? .on : .off
        menu.addItem(hideSleepItem)

        let autoStartItem = NSMenuItem(
            title: L("Start with macOS", "Lancer au démarrage du Mac"),
            action: #selector(toggleAutostart),
            keyEquivalent: ""
        )
        autoStartItem.target = self
        autoStartItem.state = isAutostartEnabled() ? .on : .off
        menu.addItem(autoStartItem)

        menu.addItem(NSMenuItem.separator())

        let refreshItem = NSMenuItem(
            title: L("Refresh now", "Actualiser maintenant"),
            action: #selector(refresh),
            keyEquivalent: "r"
        )
        refreshItem.target = self
        menu.addItem(refreshItem)

        let quitItem = NSMenuItem(
            title: L("Quit JuiceBar", "Quitter JuiceBar"),
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc func toggleDevice(_ sender: NSMenuItem) {
        let idx = sender.tag
        guard idx >= 0 && idx < devices.count else { return }
        let raw = devices[idx].rawName
        if hiddenDevices.contains(raw) {
            hiddenDevices.remove(raw)
        } else {
            hiddenDevices.insert(raw)
        }
        UserDefaults.standard.set(Array(hiddenDevices), forKey: "HiddenDevices")
        updateStatusBar()
        rebuildMenu()
    }

    @objc func toggleHideSleeping() {
        hideSleeping.toggle()
        UserDefaults.standard.set(hideSleeping, forKey: "HideSleeping")
        updateStatusBar()
        rebuildMenu()
    }

    var launchAgentURL: URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent("Library/LaunchAgents/com.juicebar.macos.plist")
    }

    func isAutostartEnabled() -> Bool {
        return FileManager.default.fileExists(atPath: launchAgentURL.path)
    }

    @objc func toggleAutostart() {
        let fm = FileManager.default
        if isAutostartEnabled() {
            try? fm.removeItem(at: launchAgentURL)
        } else {
            let exePath = Bundle.main.executablePath ?? "/Applications/JuiceBar.app/Contents/MacOS/JuiceBar"
            let plist: [String: Any] = [
                "Label": "com.juicebar.macos",
                "ProgramArguments": [exePath],
                "RunAtLoad": true,
                "ProcessType": "Interactive"
            ]
            let dir = launchAgentURL.deletingLastPathComponent()
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
            let data = try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            try? data?.write(to: launchAgentURL)
        }
        rebuildMenu()
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

// MARK: - CLI & Entry Point

let args = CommandLine.arguments
let monitor = BatteryMonitor()

if args.contains("--list") {
    let devs = monitor.poll(keepSleeping: false)
    if devs.isEmpty {
        print("No wireless devices with battery info found.")
    } else {
        for d in devs {
            print("\(d.displayName) [\(d.brand.rawValue) / \(d.kind.label)]: \(d.percent)%\(d.charging ? " (charging)" : "")")
        }
    }
    exit(0)
}

if let previewIdx = args.firstIndex(of: "--preview"), previewIdx + 1 < args.count {
    let outPath = args[previewIdx + 1]
    let sampleDevs = monitor.demoDevices()
    let barImg = renderStatusBarImage(visibleDevices: sampleDevs, isDark: true)
    let padX: CGFloat = 24
    let padY: CGFloat = 14
    let canvasSize = NSSize(width: barImg.size.width + padX * 2, height: barImg.size.height + padY * 2)
    let banner = NSImage(size: canvasSize, flipped: false) { rect in
        NSColor(srgbRed: 0.11, green: 0.12, blue: 0.15, alpha: 1.0).setFill()
        NSBezierPath(roundedRect: rect, xRadius: 10, yRadius: 10).fill()
        barImg.draw(at: NSPoint(x: padX, y: padY), from: .zero, operation: .sourceOver, fraction: 1.0)
        return true
    }
    if let tiff = banner.tiffRepresentation,
       let rep = NSBitmapImageRep(data: tiff),
       let png = rep.representation(using: .png, properties: [:]) {
        try? png.write(to: URL(fileURLWithPath: outPath))
        print("Saved preview to \(outPath)")
    }
    exit(0)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
if args.contains("--demo") {
    delegate.monitor.demoMode = true
}
app.delegate = delegate
app.run()
