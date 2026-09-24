#!/usr/bin/env swift

import AppKit
import Foundation

struct ScreenshotSpec {
    let inputName: String
    let outputName: String
    let title: String
    let subtitle: String
}

let canvasSize = CGSize(width: 2880, height: 1800)
let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let sourceRoot = rootURL.appendingPathComponent("a")
let outputRoot = rootURL.appendingPathComponent("AppStoreScreenshots")

let localizedSpecs: [String: [ScreenshotSpec]] = [
    "中文": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-快速预览与解压.png", title: "快速预览与解压", subtitle: "无需打开大型应用，直接查看压缩包内容并完成提取"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-多格式压缩管理.png", title: "多格式压缩管理", subtitle: "支持常用归档格式，批量处理文件更高效"),
    ],
    "英文": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Fast Preview and Extraction.png", title: "Fast Preview & Extraction", subtitle: "View archive contents and extract files without opening a heavy app"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Multi-format Archive Management.png", title: "Multi-format Archives", subtitle: "Create and manage common archive formats with efficient batch workflows"),
    ],
    "法语": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Apercu et extraction rapides.png", title: "Aperçu et extraction rapides", subtitle: "Consultez le contenu des archives et extrayez vos fichiers sans application lourde"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Gestion multi-format.png", title: "Gestion multi-format", subtitle: "Créez et gérez les formats d’archive courants avec des actions par lot"),
    ],
    "德语": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Schnelle Vorschau und Extraktion.png", title: "Schnelle Vorschau & Extraktion", subtitle: "Archivinhalt anzeigen und Dateien extrahieren, ohne eine große App zu öffnen"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Archivverwaltung mit vielen Formaten.png", title: "Archive in vielen Formaten", subtitle: "Erstellen und verwalten Sie gängige Archivformate mit effizienten Stapelabläufen"),
    ],
    "意大利": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Anteprima ed estrazione rapide.png", title: "Anteprima ed estrazione rapide", subtitle: "Visualizza il contenuto degli archivi ed estrai i file senza aprire app pesanti"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Gestione archivi multi-formato.png", title: "Archivi multi-formato", subtitle: "Crea e gestisci i formati più comuni con flussi di lavoro in batch"),
    ],
    "日本": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-すばやくプレビューと解凍.png", title: "すばやくプレビューと解凍", subtitle: "重いアプリを開かずに、アーカイブの内容を確認して展開できます"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-複数形式の圧縮管理.png", title: "複数形式の圧縮管理", subtitle: "一般的なアーカイブ形式を作成・管理し、まとめて効率よく処理できます"),
    ],
    "韩语": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-빠른 미리보기와 압축 해제.png", title: "빠른 미리보기와 압축 해제", subtitle: "무거운 앱을 열지 않고 압축 파일 내용을 확인하고 바로 추출하세요"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-다양한 형식의 압축 관리.png", title: "다양한 형식의 압축 관리", subtitle: "자주 쓰는 아카이브 형식을 만들고 배치 작업으로 효율적으로 관리하세요"),
    ],
    "西班牙": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Vista previa y extraccion rapidas.png", title: "Vista previa y extracción rápidas", subtitle: "Consulta el contenido de archivos comprimidos y extrae sin abrir apps pesadas"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Gestion de archivos multi-formato.png", title: "Archivos multi-formato", subtitle: "Crea y gestiona formatos comunes con flujos de trabajo por lotes"),
    ],
    "葡萄牙": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Pre-visualizacao e extracao rapidas.png", title: "Pré-visualização e extração rápidas", subtitle: "Veja o conteúdo dos arquivos e extraia sem abrir apps pesados"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Gerenciamento multi-formato.png", title: "Arquivos em vários formatos", subtitle: "Crie e gerencie formatos comuns com fluxos de trabalho em lote"),
    ],
    "波兰": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Szybki podglad i wypakowanie.png", title: "Szybki podgląd i wypakowanie", subtitle: "Przeglądaj zawartość archiwów i wypakowuj pliki bez uruchamiania ciężkich aplikacji"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Obsluga wielu formatow archiwow.png", title: "Archiwa w wielu formatach", subtitle: "Twórz i zarządzaj popularnymi formatami dzięki wygodnej pracy wsadowej"),
    ],
    "俄语": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Быстрый просмотр и распаковка.png", title: "Быстрый просмотр и распаковка", subtitle: "Просматривайте содержимое архивов и извлекайте файлы без тяжелых приложений"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Управление архивами разных форматов.png", title: "Архивы разных форматов", subtitle: "Создавайте и управляйте популярными форматами с удобной пакетной обработкой"),
    ],
    "乌克兰": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-Швидкий перегляд і розпакування.png", title: "Швидкий перегляд і розпакування", subtitle: "Переглядайте вміст архівів і витягуйте файли без важких застосунків"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-Керування архівами різних форматів.png", title: "Архіви різних форматів", subtitle: "Створюйте й керуйте популярними форматами з ефективною пакетною обробкою"),
    ],
    "波斯": [
        ScreenshotSpec(inputName: "粘贴图片.png", outputName: "01-پیش‌نمایش و استخراج سریع.png", title: "پیش‌نمایش و استخراج سریع", subtitle: "محتوای فایل‌های فشرده را ببینید و بدون اجرای برنامه‌های سنگین استخراج کنید"),
        ScreenshotSpec(inputName: "粘贴图片1.png", outputName: "02-مدیریت چندفرمتی آرشیوها.png", title: "مدیریت آرشیوهای چندفرمتی", subtitle: "فرمت‌های رایج آرشیو را بسازید و با گردش کار گروهی مدیریت کنید"),
    ],
]

func localeNamesToRender() throws -> [String] {
    let arguments = Array(CommandLine.arguments.dropFirst())
    if arguments.first == "all" {
        let urls = try FileManager.default.contentsOfDirectory(at: sourceRoot, includingPropertiesForKeys: [.isDirectoryKey])
        return urls.filter { url in
            (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
        }
        .map(\.lastPathComponent)
        .sorted()
    }
    return [arguments.first ?? "中文"]
}

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(
        calibratedRed: CGFloat((hex >> 16) & 0xff) / 255,
        green: CGFloat((hex >> 8) & 0xff) / 255,
        blue: CGFloat(hex & 0xff) / 255,
        alpha: alpha
    )
}

func paragraphStyle(alignment: NSTextAlignment = .center, lineHeight: CGFloat? = nil) -> NSParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = alignment
    if let lineHeight {
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
    }
    return style
}

func font(size: CGFloat, weight: NSFont.Weight) -> NSFont {
    NSFont.systemFont(ofSize: size, weight: weight)
}

func fittingFontSize(
    for text: String,
    baseSize: CGFloat,
    minSize: CGFloat,
    weight: NSFont.Weight,
    maxWidth: CGFloat,
    maxHeight: CGFloat,
    lineHeightMultiplier: CGFloat
) -> CGFloat {
    var size = baseSize
    while size >= minSize {
        let lineHeight = size * lineHeightMultiplier
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font(size: size, weight: weight),
            .paragraphStyle: paragraphStyle(lineHeight: lineHeight),
        ]
        let measured = NSAttributedString(string: text, attributes: attributes)
            .boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading])
        if measured.width <= maxWidth && measured.height <= maxHeight {
            return size
        }
        size -= 2
    }
    return minSize
}

func drawCenteredText(_ text: String, in rect: CGRect, attributes: [NSAttributedString.Key: Any]) {
    let attributed = NSAttributedString(string: text, attributes: attributes)
    attributed.draw(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading])
}

func drawRoundedRect(_ rect: CGRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

extension NSBezierPath {
    func fill(with fillColor: NSColor) {
        fillColor.setFill()
        fill()
    }
}

func savePNG(_ bitmap: NSBitmapImageRep, to url: URL) throws {
    guard let png = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "ScreenshotGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode PNG"])
    }
    try png.write(to: url)
}

func drawBackground(in rect: CGRect) {
    let gradient = NSGradient(colors: [
        color(0xf7fbff),
        color(0xeaf3f8),
        color(0xf9fbf6),
    ])!
    gradient.draw(in: rect, angle: 90)

    color(0x2f7d7e, 0.10).setFill()
    NSBezierPath(ovalIn: CGRect(x: -180, y: 1110, width: 620, height: 620)).fill()
    color(0xf2b84b, 0.12).setFill()
    NSBezierPath(ovalIn: CGRect(x: rect.width - 520, y: 1180, width: 620, height: 620)).fill()
    color(0x234c63, 0.08).setFill()
    NSBezierPath(ovalIn: CGRect(x: rect.width - 700, y: -160, width: 760, height: 760)).fill()
}

func render(spec: ScreenshotSpec, sourceDir: URL, outputDir: URL) throws {
    let inputURL = sourceDir.appendingPathComponent(spec.inputName)
    guard let sourceImage = NSImage(contentsOf: inputURL) else {
        throw NSError(domain: "ScreenshotGenerator", code: 2, userInfo: [NSLocalizedDescriptionKey: "Cannot open \(inputURL.path)"])
    }

    guard
        let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(canvasSize.width),
            pixelsHigh: Int(canvasSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ),
        let context = NSGraphicsContext(bitmapImageRep: bitmap)
    else {
        throw NSError(domain: "ScreenshotGenerator", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to create bitmap context"])
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    defer { NSGraphicsContext.restoreGraphicsState() }

    let canvas = CGRect(origin: .zero, size: canvasSize)
    drawBackground(in: canvas)

    let contentWidth = min(canvasSize.width - 320, 2200)
    let contentX = (canvasSize.width - contentWidth) / 2
    let titleRect = CGRect(x: contentX, y: 1450, width: contentWidth, height: 170)
    let titleSize = fittingFontSize(
        for: spec.title,
        baseSize: 112,
        minSize: 66,
        weight: .semibold,
        maxWidth: titleRect.width,
        maxHeight: titleRect.height,
        lineHeightMultiplier: 1.12
    )
    let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: font(size: titleSize, weight: .semibold),
        .foregroundColor: color(0x102733),
        .paragraphStyle: paragraphStyle(lineHeight: titleSize * 1.12),
    ]
    drawCenteredText(spec.title, in: titleRect, attributes: titleAttributes)

    let subtitleWidth = min(canvasSize.width - 420, 2140)
    let subtitleRect = CGRect(x: (canvasSize.width - subtitleWidth) / 2, y: 1368, width: subtitleWidth, height: 96)
    let subtitleSize = fittingFontSize(
        for: spec.subtitle,
        baseSize: 43,
        minSize: 32,
        weight: .regular,
        maxWidth: subtitleRect.width,
        maxHeight: subtitleRect.height,
        lineHeightMultiplier: 1.3
    )
    let subtitleAttributes: [NSAttributedString.Key: Any] = [
        .font: font(size: subtitleSize, weight: .regular),
        .foregroundColor: color(0x42616d),
        .paragraphStyle: paragraphStyle(lineHeight: subtitleSize * 1.3),
    ]
    drawCenteredText(spec.subtitle, in: subtitleRect, attributes: subtitleAttributes)

    let badgeRect = CGRect(x: (canvasSize.width - 324) / 2, y: 1265, width: 324, height: 62)
    drawRoundedRect(badgeRect, radius: 31, fill: color(0xffffff, 0.62), stroke: color(0xbfd5da, 0.6), lineWidth: 1)
    let badgeAttributes: [NSAttributedString.Key: Any] = [
        .font: font(size: 28, weight: .medium),
        .foregroundColor: color(0x2c6975),
        .paragraphStyle: paragraphStyle(lineHeight: 36),
    ]
    drawCenteredText("ZipTool Pro for Mac", in: CGRect(x: badgeRect.minX, y: badgeRect.minY + 12, width: badgeRect.width, height: 38), attributes: badgeAttributes)

    let screenshotWidth = min(canvasSize.width - 480, 2100)
    let screenshotHeight = screenshotWidth * (1000 / 1938)
    let screenshotTarget = CGRect(
        x: (canvasSize.width - screenshotWidth) / 2,
        y: 150,
        width: screenshotWidth,
        height: screenshotHeight
    )
    let shadow = NSShadow()
    shadow.shadowColor = color(0x123141, 0.22)
    shadow.shadowOffset = CGSize(width: 0, height: -26)
    shadow.shadowBlurRadius = 42

    NSGraphicsContext.saveGraphicsState()
    shadow.set()
    drawRoundedRect(screenshotTarget, radius: 34, fill: color(0xffffff))
    NSGraphicsContext.restoreGraphicsState()

    drawRoundedRect(screenshotTarget, radius: 34, fill: color(0xf7f9fa), stroke: color(0xd0dee2), lineWidth: 2)

    let contentRect = screenshotTarget.insetBy(dx: 1, dy: 1)
    let clipPath = NSBezierPath(roundedRect: contentRect, xRadius: 24, yRadius: 24)
    NSGraphicsContext.saveGraphicsState()
    clipPath.addClip()

    let sourceSize = sourceImage.size
    color(0xffffff).setFill()
    contentRect.fill()

    let scale = min(contentRect.width / sourceSize.width, contentRect.height / sourceSize.height)
    let drawSize = CGSize(width: sourceSize.width * scale, height: sourceSize.height * scale)
    let drawRect = CGRect(
        x: contentRect.midX - drawSize.width / 2,
        y: contentRect.midY - drawSize.height / 2,
        width: drawSize.width,
        height: drawSize.height
    )
    sourceImage.draw(in: drawRect, from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
    NSGraphicsContext.restoreGraphicsState()

    try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    try savePNG(bitmap, to: outputDir.appendingPathComponent(spec.outputName))
}

do {
    let localeNames = try localeNamesToRender()
    var generatedCount = 0
    for localeName in localeNames {
        guard let specs = localizedSpecs[localeName] else {
            fputs("Warning: Missing text specs for \(localeName), skipped.\n", stderr)
            continue
        }

        let sourceDir = sourceRoot.appendingPathComponent(localeName)
        let outputDir = outputRoot.appendingPathComponent(localeName)
        for spec in specs {
            try render(spec: spec, sourceDir: sourceDir, outputDir: outputDir)
            generatedCount += 1
        }
        print("Generated \(specs.count) screenshots in \(outputDir.path)")
    }
    print("Done. Generated \(generatedCount) screenshots.")
} catch {
    fputs("Error: \(error.localizedDescription)\n", stderr)
    exit(1)
}
