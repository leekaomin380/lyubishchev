#!/usr/bin/env swift

import AppKit
import CoreGraphics

let size = 1024
let imgSize = NSSize(width: size, height: size)

let image = NSImage(size: imgSize, flipped: false) { rect in
    guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
    let w = rect.width
    let h = rect.height
    let colorSpace = CGColorSpaceCreateDeviceRGB()

    // === macOS rounded-rect icon mask ===
    let iconRect = rect.insetBy(dx: 20, dy: 20)
    let iconPath = NSBezierPath(roundedRect: iconRect, xRadius: 185, yRadius: 185)

    ctx.saveGState()
    iconPath.addClip()

    // === Background: warm but muted, slightly pink-cream to contrast with yellow sand ===
    let bgColors = [
        CGColor(red: 0.98, green: 0.95, blue: 0.88, alpha: 1.0),   // top: warm cream
        CGColor(red: 0.94, green: 0.89, blue: 0.80, alpha: 1.0),   // mid
        CGColor(red: 0.90, green: 0.84, blue: 0.74, alpha: 1.0)    // bottom: warm tan
    ] as CFArray
    let bgLocations: [CGFloat] = [0.0, 0.5, 1.0]
    if let bgGrad = CGGradient(colorsSpace: colorSpace, colors: bgColors, locations: bgLocations) {
        ctx.drawLinearGradient(bgGrad,
            start: CGPoint(x: w/2, y: h),
            end: CGPoint(x: w/2, y: 0),
            options: [])
    }

    // === Hourglass — short, wide, centered ===
    let hgCX = w * 0.5
    let hgCY = h * 0.48
    let hgW: CGFloat = 440       // wider
    let hgH: CGFloat = 540       // shorter — 矮胖
    let neckW: CGFloat = 44
    let barH: CGFloat = 32
    let barExtra: CGFloat = 35

    // === Drop shadow under the hourglass for depth (Preview.app style) ===
    ctx.saveGState()
    let shadowRect = NSRect(x: hgCX - hgW/2 - 10, y: hgCY - hgH/2 - barH, width: hgW + 20, height: hgH + barH * 2)
    ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 30,
                  color: CGColor(red: 0.3, green: 0.25, blue: 0.15, alpha: 0.25))
    NSColor.clear.setFill()
    // Draw an invisible shape to cast shadow
    let shadowShape = NSBezierPath(roundedRect: shadowRect.insetBy(dx: 40, dy: 20), xRadius: 30, yRadius: 30)
    NSColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 0.3).setFill()
    shadowShape.fill()
    ctx.restoreGState()

    // === Frame bars (wood/brass feel, flat) ===
    // Bottom bar — darker
    let frameDark = NSColor(red: 0.52, green: 0.40, blue: 0.24, alpha: 1.0)
    let frameLight = NSColor(red: 0.65, green: 0.52, blue: 0.32, alpha: 1.0)
    let frameHighlight = NSColor(red: 0.75, green: 0.63, blue: 0.42, alpha: 1.0)

    // Bottom bar
    let botBarRect = NSRect(x: hgCX - hgW/2 - barExtra,
                            y: hgCY - hgH/2 - barH/2,
                            width: hgW + barExtra * 2, height: barH)
    frameDark.setFill()
    NSBezierPath(roundedRect: botBarRect, xRadius: 7, yRadius: 7).fill()
    // Highlight stripe on bottom bar
    frameLight.setFill()
    let botHighlight = NSRect(x: botBarRect.minX + 4, y: botBarRect.minY + barH * 0.6,
                              width: botBarRect.width - 8, height: barH * 0.25)
    NSBezierPath(roundedRect: botHighlight, xRadius: 3, yRadius: 3).fill()

    // Top bar
    let topBarRect = NSRect(x: hgCX - hgW/2 - barExtra,
                            y: hgCY + hgH/2 - barH/2,
                            width: hgW + barExtra * 2, height: barH)
    frameLight.setFill()
    NSBezierPath(roundedRect: topBarRect, xRadius: 7, yRadius: 7).fill()
    frameHighlight.setFill()
    let topHighlight = NSRect(x: topBarRect.minX + 4, y: topBarRect.minY + barH * 0.6,
                              width: topBarRect.width - 8, height: barH * 0.25)
    NSBezierPath(roundedRect: topHighlight, xRadius: 3, yRadius: 3).fill()

    // Decorative feet / caps
    let capW: CGFloat = 22
    let capH: CGFloat = 16
    for xOff in [-1.0, 1.0] as [CGFloat] {
        let cx = hgCX + xOff * (hgW/2 + barExtra - 22)
        frameDark.setFill()
        NSBezierPath(roundedRect: NSRect(x: cx - capW/2, y: hgCY - hgH/2 - barH/2 - capH + 5,
                                          width: capW, height: capH), xRadius: 5, yRadius: 5).fill()
        frameLight.setFill()
        NSBezierPath(roundedRect: NSRect(x: cx - capW/2, y: hgCY + hgH/2 + barH/2 - 5,
                                          width: capW, height: capH), xRadius: 5, yRadius: 5).fill()
    }

    // Side posts
    let postColor = NSColor(red: 0.56, green: 0.45, blue: 0.28, alpha: 0.8)
    postColor.setStroke()
    for xOff in [-1.0, 1.0] as [CGFloat] {
        let px = hgCX + xOff * (hgW/2 + 10)
        let post = NSBezierPath()
        post.lineWidth = 7
        post.move(to: NSPoint(x: px, y: hgCY + hgH/2 - barH/2))
        post.line(to: NSPoint(x: px, y: hgCY - hgH/2 + barH/2))
        post.stroke()
    }

    // === Glass body — two halves, clear contrast against background ===
    // Top glass half
    let topGlass = NSBezierPath()
    topGlass.move(to: NSPoint(x: hgCX - hgW/2, y: hgCY + hgH/2 - barH/2))
    topGlass.curve(to: NSPoint(x: hgCX - neckW/2, y: hgCY),
                   controlPoint1: NSPoint(x: hgCX - hgW/2, y: hgCY + hgH * 0.06),
                   controlPoint2: NSPoint(x: hgCX - neckW/2, y: hgCY + hgH * 0.04))
    topGlass.line(to: NSPoint(x: hgCX + neckW/2, y: hgCY))
    topGlass.curve(to: NSPoint(x: hgCX + hgW/2, y: hgCY + hgH/2 - barH/2),
                   controlPoint1: NSPoint(x: hgCX + neckW/2, y: hgCY + hgH * 0.04),
                   controlPoint2: NSPoint(x: hgCX + hgW/2, y: hgCY + hgH * 0.06))
    topGlass.close()

    // Bottom glass half
    let botGlass = NSBezierPath()
    botGlass.move(to: NSPoint(x: hgCX - hgW/2, y: hgCY - hgH/2 + barH/2))
    botGlass.curve(to: NSPoint(x: hgCX - neckW/2, y: hgCY),
                   controlPoint1: NSPoint(x: hgCX - hgW/2, y: hgCY - hgH * 0.06),
                   controlPoint2: NSPoint(x: hgCX - neckW/2, y: hgCY - hgH * 0.04))
    botGlass.line(to: NSPoint(x: hgCX + neckW/2, y: hgCY))
    botGlass.curve(to: NSPoint(x: hgCX + hgW/2, y: hgCY - hgH/2 + barH/2),
                   controlPoint1: NSPoint(x: hgCX + neckW/2, y: hgCY - hgH * 0.04),
                   controlPoint2: NSPoint(x: hgCX + hgW/2, y: hgCY - hgH * 0.06))
    botGlass.close()

    // --- Glass fill: bright white with gradient for flat glass feel ---
    // Top half glass
    ctx.saveGState()
    topGlass.addClip()
    let glassColors = [
        CGColor(red: 1.0, green: 1.0, blue: 0.99, alpha: 0.92),
        CGColor(red: 0.96, green: 0.95, blue: 0.92, alpha: 0.80),
        CGColor(red: 0.92, green: 0.90, blue: 0.86, alpha: 0.75)
    ] as CFArray
    let glassLoc: [CGFloat] = [0.0, 0.5, 1.0]
    if let gGrad = CGGradient(colorsSpace: colorSpace, colors: glassColors, locations: glassLoc) {
        ctx.drawLinearGradient(gGrad,
            start: CGPoint(x: hgCX - hgW/2, y: h/2),
            end: CGPoint(x: hgCX + hgW/2, y: h/2),
            options: [])
    }
    ctx.restoreGState()

    // Bottom half glass
    ctx.saveGState()
    botGlass.addClip()
    if let gGrad = CGGradient(colorsSpace: colorSpace, colors: glassColors, locations: glassLoc) {
        ctx.drawLinearGradient(gGrad,
            start: CGPoint(x: hgCX - hgW/2, y: h/2),
            end: CGPoint(x: hgCX + hgW/2, y: h/2),
            options: [])
    }
    ctx.restoreGState()

    // --- Flat glass reflection: vertical light stripe on left side ---
    ctx.saveGState()
    topGlass.addClip()
    let refColors = [
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0),
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.55),
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.55),
        CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    ] as CFArray
    let refLoc: [CGFloat] = [0.0, 0.35, 0.45, 1.0]
    if let refGrad = CGGradient(colorsSpace: colorSpace, colors: refColors, locations: refLoc) {
        ctx.drawLinearGradient(refGrad,
            start: CGPoint(x: hgCX - hgW/2 - 20, y: h/2),
            end: CGPoint(x: hgCX - hgW/2 + 140, y: h/2),
            options: [])
    }
    ctx.restoreGState()

    ctx.saveGState()
    botGlass.addClip()
    if let refGrad = CGGradient(colorsSpace: colorSpace, colors: refColors, locations: refLoc) {
        ctx.drawLinearGradient(refGrad,
            start: CGPoint(x: hgCX - hgW/2 - 20, y: h/2),
            end: CGPoint(x: hgCX - hgW/2 + 140, y: h/2),
            options: [])
    }
    ctx.restoreGState()

    // === Sand in top half ===
    ctx.saveGState()
    topGlass.addClip()

    let sandLevel = hgCY + hgH * 0.10
    let sandColor1 = NSColor(red: 0.92, green: 0.73, blue: 0.33, alpha: 1.0)
    let sandColor2 = NSColor(red: 0.85, green: 0.65, blue: 0.28, alpha: 1.0)

    // Sand gradient fill
    let sandRect = NSRect(x: hgCX - hgW, y: hgCY, width: hgW * 2, height: sandLevel - hgCY)
    let sandColors = [
        sandColor1.cgColor,
        sandColor2.cgColor
    ] as CFArray
    let sandLoc: [CGFloat] = [0.0, 1.0]
    if let sGrad = CGGradient(colorsSpace: colorSpace, colors: sandColors, locations: sandLoc) {
        ctx.drawLinearGradient(sGrad,
            start: CGPoint(x: hgCX, y: sandLevel),
            end: CGPoint(x: hgCX, y: hgCY),
            options: [.drawsBeforeStartLocation])
    }

    // Clear above sand level
    ctx.setBlendMode(.clear)
    ctx.fill(CGRect(x: 0, y: sandLevel, width: w, height: h))
    ctx.setBlendMode(.normal)

    ctx.restoreGState()

    // === Sand stream ===
    let streamColor = NSColor(red: 0.88, green: 0.68, blue: 0.28, alpha: 0.9)
    streamColor.setStroke()
    let stream = NSBezierPath()
    stream.lineWidth = 6
    stream.move(to: NSPoint(x: hgCX, y: hgCY + hgH * 0.03))
    stream.line(to: NSPoint(x: hgCX, y: hgCY - hgH * 0.18))
    stream.stroke()

    // === Sand pile at bottom ===
    ctx.saveGState()
    botGlass.addClip()

    let pileTop = hgCY - hgH * 0.18
    let pileBot = hgCY - hgH/2

    let pile = NSBezierPath()
    pile.move(to: NSPoint(x: hgCX - hgW, y: pileBot))
    pile.line(to: NSPoint(x: hgCX - hgW, y: pileTop - 60))
    pile.curve(to: NSPoint(x: hgCX, y: pileTop),
               controlPoint1: NSPoint(x: hgCX - hgW * 0.25, y: pileTop - 60),
               controlPoint2: NSPoint(x: hgCX - hgW * 0.12, y: pileTop))
    pile.curve(to: NSPoint(x: hgCX + hgW, y: pileTop - 60),
               controlPoint1: NSPoint(x: hgCX + hgW * 0.12, y: pileTop),
               controlPoint2: NSPoint(x: hgCX + hgW * 0.25, y: pileTop - 60))
    pile.line(to: NSPoint(x: hgCX + hgW, y: pileBot))
    pile.close()

    // Sand pile gradient
    let pileColors = [
        CGColor(red: 0.90, green: 0.72, blue: 0.32, alpha: 1.0),
        CGColor(red: 0.82, green: 0.62, blue: 0.26, alpha: 1.0)
    ] as CFArray
    let pileLoc: [CGFloat] = [0.0, 1.0]

    sandColor1.setFill()
    pile.fill()

    // Darker bottom
    if let pGrad = CGGradient(colorsSpace: colorSpace, colors: pileColors, locations: pileLoc) {
        ctx.drawLinearGradient(pGrad,
            start: CGPoint(x: hgCX, y: pileTop),
            end: CGPoint(x: hgCX, y: pileBot),
            options: [.drawsAfterEndLocation])
    }

    ctx.restoreGState()

    // === Glass outline — clear defined edges ===
    let outlineColor = NSColor(red: 0.45, green: 0.38, blue: 0.24, alpha: 0.45)
    outlineColor.setStroke()
    topGlass.lineWidth = 4.5
    topGlass.stroke()
    botGlass.lineWidth = 4.5
    botGlass.stroke()

    ctx.restoreGState()

    // === Icon border ===
    let borderColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
    borderColor.setStroke()
    iconPath.lineWidth = 2
    iconPath.stroke()

    return true
}

// Save as PNG
guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:]) else {
    print("Failed to create PNG data")
    exit(1)
}

let pngPath = "/Users/gm/Projects/lyubishchev/icon_1024.png"
do {
    try pngData.write(to: URL(fileURLWithPath: pngPath))
    print("Icon saved to \(pngPath)")
} catch {
    print("Failed to write: \(error)")
    exit(1)
}
