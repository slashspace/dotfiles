import AppKit

// Draw the app icon at the bar's device-pixel size. SketchyBar blits images
// with nearest-neighbor, so a 64px PNG shown at scale 0.5 lands 1:1 on the
// 2x window (32pt) and keeps the squircle edge smooth.
let name = CommandLine.arguments[1]
let out = CommandLine.arguments[2]
let mark = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : ""
let ws = NSWorkspace.shared

var url: URL?
for app in ws.runningApplications where app.localizedName == name {
    url = app.bundleURL
    break
}
if url == nil {
    url = ws.urlForApplication(withBundleIdentifier: name)
}
guard let url else {
    fputs("front-app-icon: no bundle for \(name)\n", stderr)
    exit(1)
}

let icon = ws.icon(forFile: url.path)
let pixels = 64
guard let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: pixels,
    pixelsHigh: pixels,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
) else {
    exit(1)
}

NSGraphicsContext.saveGraphicsState()
guard let context = NSGraphicsContext(bitmapImageRep: rep) else { exit(1) }
NSGraphicsContext.current = context
context.imageInterpolation = .high
context.cgContext.interpolationQuality = .high
context.cgContext.clear(CGRect(x: 0, y: 0, width: pixels, height: pixels))
icon.draw(
    in: NSRect(x: 0, y: 0, width: pixels, height: pixels),
    from: .zero,
    operation: .sourceOver,
    fraction: 1,
    respectFlipped: false,
    hints: [.interpolation: NSNumber(value: NSImageInterpolation.high.rawValue)]
)
if !mark.isEmpty {
    let badge: CGFloat = 26
    let rect = NSRect(x: CGFloat(pixels) - badge - 1, y: 1, width: badge, height: badge)
    let path = NSBezierPath(roundedRect: rect, xRadius: 8, yRadius: 8)
    NSColor(srgbRed: 0.039, green: 0.039, blue: 0.039, alpha: 0.92).setFill()
    path.fill()
    let base = NSFont(name: "JetBrainsMono Nerd Font", size: 16) ?? NSFont.boldSystemFont(ofSize: 16)
    let font = NSFontManager.shared.convert(base, toHaveTrait: .boldFontMask)
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: NSColor.white,
        .paragraphStyle: style,
    ]
    let text = NSString(string: mark)
    let textSize = text.size(withAttributes: attrs)
    text.draw(
        in: NSRect(
            x: rect.minX,
            y: rect.midY - textSize.height / 2,
            width: rect.width,
            height: textSize.height
        ),
        withAttributes: attrs
    )
}
NSGraphicsContext.restoreGraphicsState()

guard let data = rep.representation(using: .png, properties: [:]) else { exit(1) }
try data.write(to: URL(fileURLWithPath: out))
