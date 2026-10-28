import AppKit
import Darwin
import Foundation

let cacheDir = URL(fileURLWithPath: NSHomeDirectory() + "/.cache/sketchybar", isDirectory: true)
let popupFlag = cacheDir.appendingPathComponent("cliamp-popup.on")
let barHidden = cacheDir.appendingPathComponent("cliamp-bar.off")
let lyricsFile = cacheDir.appendingPathComponent("cliamp-lyrics.json")
let barCount = 40

let cyan = NSColor(srgbRed: 0.55, green: 0.87, blue: 0.78, alpha: 1)
let orange = NSColor(srgbRed: 0.96, green: 0.64, blue: 0.29, alpha: 1)
let peakColor = NSColor(srgbRed: 0.96, green: 0.73, blue: 0.34, alpha: 0.9)
let white = NSColor(srgbRed: 0.77, green: 0.76, blue: 0.72, alpha: 1)
let grey = NSColor(srgbRed: 0.55, green: 0.54, blue: 0.53, alpha: 1)
let track = NSColor(srgbRed: 0.28, green: 0.28, blue: 0.28, alpha: 1)
let black = NSColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)

var smooth = [Double]()
var peaks = [Double]()
var slots: [String: Int] = [:]
var inflight: [String: Process] = [:]

var trackTitle = ""
var trackArtist = ""
var trackAlbum = ""
var playState = ""
var duration = 0.0
var positionAtPoll = 0.0
var pollTime = Date.distantPast
var lastPopupSignature = ""
var lyrics: [(start: Double, text: String)] = []

func barWanted() -> Bool {
    !FileManager.default.fileExists(atPath: barHidden.path)
}

func popupWanted() -> Bool {
    FileManager.default.fileExists(atPath: popupFlag.path)
}

func needsStream() -> Bool {
    barWanted()
}

func number(_ value: Any?) -> Double {
    (value as? NSNumber)?.doubleValue ?? 0
}

func font(_ size: CGFloat) -> NSFont {
    let names = ["JetBrainsMono Nerd Font", "Hiragino Sans GB", ".AppleSystemUIFont"]
    for name in names {
        if let font = NSFont(name: name, size: size) {
            return font
        }
    }
    return NSFont.systemFont(ofSize: size)
}

func levels(from bands: [Double]) -> [Double] {
    let grouped = bucket(bands, count: barCount)
    let peak = grouped.max() ?? 0
    let scaled: [Double]
    if peak < 1e-8 {
        scaled = Array(repeating: 0, count: barCount)
    } else if peak <= 1.2 {
        scaled = grouped.map { min(1, max(0, $0)) }
    } else {
        let floor = log10(peak) - 2.2
        scaled = grouped.map { value in
            guard value > 0 else { return 0 }
            return min(1, max(0, (log10(value) - floor) / 2.2))
        }
    }
    if smooth.count != scaled.count {
        smooth = scaled
    } else {
        for index in scaled.indices {
            smooth[index] = smooth[index] * 0.42 + scaled[index] * 0.58
        }
    }
    if peaks.count != smooth.count {
        peaks = smooth
    } else {
        for index in smooth.indices {
            if smooth[index] >= peaks[index] {
                peaks[index] = smooth[index]
            } else {
                peaks[index] = max(smooth[index], peaks[index] - 0.04)
            }
        }
    }
    return smooth
}

func bucket(_ bands: [Double], count: Int) -> [Double] {
    guard !bands.isEmpty else { return Array(repeating: 0, count: count) }
    var out = Array(repeating: 0.0, count: count)
    for index in 0..<count {
        let start = index * bands.count / count
        let end = max(start + 1, (index + 1) * bands.count / count)
        let slice = bands[start..<end]
        out[index] = slice.reduce(0, +) / Double(slice.count)
    }
    return out
}

func bitmap(width: Int, height: Int, _ draw: (NSRect) -> Void) -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    draw(NSRect(x: 0, y: 0, width: width, height: height))
    NSGraphicsContext.restoreGraphicsState()
    return rep
}

func fill(_ rect: NSRect, _ color: NSColor, radius: CGFloat = 1) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func drawBars(in canvas: NSRect, values: [Double], caps: [Double]) {
    let count = values.count
    guard count > 0 else { return }
    let gap: CGFloat = canvas.width > 400 ? 5 : 3
    let barW = max(2, (canvas.width - gap * CGFloat(count - 1)) / CGFloat(count))
    let used = barW * CGFloat(count) + gap * CGFloat(count - 1)
    var x = canvas.minX + (canvas.width - used) / 2
    for index in 0..<count {
        let level = CGFloat(values[index])
        let cap = CGFloat(caps[index])
        if level < 0.05 {
            fill(
                NSRect(x: x, y: canvas.minY, width: barW, height: 2),
                cyan.withAlphaComponent(0.35),
                radius: 1
            )
        } else {
            let height = max(3, level * canvas.height)
            let split = height * 0.55
            fill(NSRect(x: x, y: canvas.minY, width: barW, height: split), cyan, radius: 1)
            if height - split > 1 {
                fill(
                    NSRect(x: x, y: canvas.minY + split, width: barW, height: height - split),
                    orange,
                    radius: 1
                )
            }
        }
        if cap > level + 0.04 {
            let capY = canvas.minY + cap * canvas.height + 2
            fill(NSRect(x: x, y: min(canvas.maxY - 2, capY), width: barW, height: 2), peakColor, radius: 1)
        }
        x += barW + gap
    }
}

func drawProgress(in rect: NSRect, fraction: Double) {
    fill(rect, track, radius: rect.height / 2)
    let played = max(0, min(1, fraction))
    let playedW = rect.width * CGFloat(played)
    if playedW > 1 {
        fill(NSRect(x: rect.minX, y: rect.minY, width: playedW, height: rect.height), orange, radius: rect.height / 2)
    }
    let knob: CGFloat = rect.height + 7
    let knobX = rect.minX + playedW - knob / 2
    fill(
        NSRect(x: knobX, y: rect.midY - knob / 2, width: knob, height: knob),
        orange,
        radius: knob / 2
    )
}

func progressFraction() -> Double {
    guard duration > 0 else { return 0 }
    var position = positionAtPoll
    if playState == "playing" {
        position += Date().timeIntervalSince(pollTime)
    }
    return min(1, max(0, position / duration))
}

func drawBarImage(values: [Double]) -> NSBitmapImageRep {
    bitmap(width: 336, height: 64) { _ in
        drawBars(
            in: NSRect(x: 8, y: 16, width: 320, height: 44),
            values: values,
            caps: peaks
        )
        drawProgress(in: NSRect(x: 8, y: 6, width: 320, height: 3), fraction: progressFraction())
    }
}

func drawString(_ text: String, _ rect: NSRect, _ color: NSColor, _ size: CGFloat) {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    style.lineBreakMode = .byTruncatingTail
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font(size),
        .foregroundColor: color,
        .paragraphStyle: style,
    ]
    NSString(string: text).draw(in: rect, withAttributes: attrs)
}

func lyricWindow() -> [(text: String, current: Bool)] {
    let position = positionAtPoll + (playState == "playing" ? Date().timeIntervalSince(pollTime) : 0)
    let lines = lyrics.filter { !$0.text.trimmingCharacters(in: .whitespaces).isEmpty }
    guard !lines.isEmpty else { return [] }
    var current = 0
    for (index, line) in lines.enumerated() where line.start <= position {
        current = index
    }
    let start = max(0, current - 2)
    let end = min(lines.count, start + 5)
    return lines[start..<end].enumerated().map { offset, line in
        (line.text, start + offset == current)
    }
}

func drawPopupImage() -> NSBitmapImageRep {
    bitmap(width: 720, height: 360) { canvas in
        fill(canvas, black, radius: 0)
        var y = canvas.maxY - 32
        let title = trackTitle.isEmpty ? " " : trackTitle
        y -= 36
        drawString(title, NSRect(x: 24, y: y, width: 672, height: 36), white, 26)
        y -= 6
        let artist = trackArtist.isEmpty ? " " : trackArtist
        y -= 28
        drawString(artist, NSRect(x: 24, y: y, width: 672, height: 28), grey, 20)
        if !trackAlbum.isEmpty && trackAlbum != trackTitle {
            y -= 4
            y -= 26
            drawString(trackAlbum, NSRect(x: 24, y: y, width: 672, height: 26), grey.withAlphaComponent(0.8), 18)
        }
        y -= 20
        let lines = lyricWindow()
        if lines.isEmpty {
            y -= 30
            drawString("暂无歌词", NSRect(x: 24, y: y, width: 672, height: 30), grey, 20)
        } else {
            for line in lines {
                y -= 30
                drawString(
                    line.text,
                    NSRect(x: 24, y: y, width: 672, height: 30),
                    line.current ? white : grey,
                    line.current ? 22 : 18
                )
                y -= 2
            }
        }
    }
}

func popupSignature() -> String {
    let lines = lyricWindow().map { ($0.current ? "*" : " ") + $0.text }.joined(separator: "\n")
    return [trackTitle, trackArtist, trackAlbum, lines].joined(separator: "\n")
}

func publishPopupIfNeeded() {
    guard popupWanted() else { return }
    refreshMetadata()
    let signature = popupSignature()
    if signature == lastPopupSignature { return }
    lastPopupSignature = signature
    publish(drawPopupImage(), item: "cliamp.card", prefix: "cliamp-popup")
}

func publish(_ rep: NSBitmapImageRep, item: String, prefix: String) {
    if let running = inflight[item] {
        if running.isRunning { return }
        running.waitUntilExit()
    }
    let slot = (slots[prefix] ?? 0) ^ 1
    slots[prefix] = slot
    let url = cacheDir.appendingPathComponent("\(prefix)-\(slot).png")
    guard let data = rep.representation(using: .png, properties: [:]) else { return }
    try? data.write(to: url, options: .atomic)
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/sketchybar")
    process.arguments = [
        "--set", item,
        "background.drawing=on",
        "background.image=\(url.path)",
        "background.image.drawing=on",
        "background.image.scale=0.5",
    ]
    process.standardOutput = FileHandle.nullDevice
    process.standardError = FileHandle.nullDevice
    try? process.run()
    inflight[item] = process
}

func refreshMetadata() {
    guard Date().timeIntervalSince(pollTime) > 2 else { return }
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/cliamp")
    process.arguments = ["status", "--json"]
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = FileHandle.nullDevice
    try? process.run()
    let deadline = Date().addingTimeInterval(0.3)
    while process.isRunning && Date() < deadline {
        Thread.sleep(forTimeInterval: 0.02)
    }
    if process.isRunning {
        process.terminate()
        pollTime = Date()
        return
    }
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        (json["ok"] as? Bool) == true
    else { return }
    playState = json["state"] as? String ?? ""
    duration = number(json["duration"])
    positionAtPoll = number(json["position"])
    pollTime = Date()
    let track = json["track"] as? [String: Any] ?? [:]
    trackTitle = track["title"] as? String ?? ""
    trackArtist = track["artist"] as? String ?? ""
    trackAlbum = track["album"] as? String ?? ""
    if let lyricData = try? Data(contentsOf: lyricsFile),
       let rows = try? JSONSerialization.jsonObject(with: lyricData) as? [[String: Any]] {
        lyrics = rows.compactMap { row in
            guard let text = row["text"] as? String else { return nil }
            return (number(row["start"]), text)
        }
    }
}

func render(bands: [Double]) {
    refreshMetadata()
    let values = levels(from: bands)
    if barWanted() {
        publish(drawBarImage(values: values), item: "cliamp.vis", prefix: "cliamp-bar")
    }
    publishPopupIfNeeded()
}

func streamOnce() -> Bool {
    var stoppedIdle = false
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/cliamp")
    process.arguments = ["visstream", "--fps", "12"]
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = FileHandle.nullDevice
    do {
        try process.run()
    } catch {
        return false
    }
    let fd = pipe.fileHandleForReading.fileDescriptor
    let flags = fcntl(fd, F_GETFL)
    if flags >= 0 {
        _ = fcntl(fd, F_SETFL, flags | O_NONBLOCK)
    }
    var buffer = Data()
    var lastFrame = Date()
    while process.isRunning {
        if !needsStream() {
            stoppedIdle = true
            break
        }
        var tmp = [UInt8](repeating: 0, count: 16384)
        let n = read(fd, &tmp, tmp.count)
        if n > 0 {
            buffer.append(contentsOf: tmp.prefix(n))
            while let newline = buffer.firstIndex(of: 10) {
                let line = buffer.prefix(upTo: newline)
                buffer.removeSubrange(...newline)
                guard
                    let json = try? JSONSerialization.jsonObject(with: Data(line)) as? [String: Any],
                    let raw = json["bands"] as? [Any]
                else { continue }
                lastFrame = Date()
                render(bands: raw.compactMap { ($0 as? NSNumber)?.doubleValue })
            }
        } else if n == 0 {
            break
        } else if errno != EAGAIN && errno != EWOULDBLOCK {
            break
        }
        if Date().timeIntervalSince(lastFrame) > 2 {
            break
        }
        Thread.sleep(forTimeInterval: 0.05)
    }
    if process.isRunning {
        process.terminate()
    }
    process.waitUntilExit()
    return stoppedIdle
}

try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
while true {
    if popupWanted() {
        publishPopupIfNeeded()
    }
    if !needsStream() {
        Thread.sleep(forTimeInterval: 0.3)
        continue
    }
    if streamOnce() {
        continue
    }
    Thread.sleep(forTimeInterval: 2)
}
