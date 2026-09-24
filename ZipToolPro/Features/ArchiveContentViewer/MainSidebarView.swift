//
//  MainSidebarView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import AppKit
import Core
import SwiftUI
import tb
import UniformTypeIdentifiers

private let sidebarLog = tb.Logger(subsystem: "app.ZipToolPro", category: "archive")

enum AppLocalization {
    static let selectedLanguageCodeKey = "selectedLanguageCode"

    static func localeIdentifier(for languageCode: String?) -> String {
        guard let languageCode, !languageCode.isEmpty else {
            return Locale.current.identifier
        }
        return languageCode
    }

    static func localizedString(_ key: String, _ arguments: CVarArg...) -> String {
        let format = localizedString(key)
        return String(
            format: format,
            locale: Locale(identifier: localeIdentifier(for: selectedLanguageCode)),
            arguments: arguments
        )
    }

    static func localizedString(_ key: String) -> String {
        bundle(for: selectedLanguageCode).localizedString(forKey: key, value: nil, table: nil)
    }

    private static var selectedLanguageCode: String? {
        UserDefaults.standard.string(forKey: selectedLanguageCodeKey)
    }

    private static func bundle(for languageCode: String?) -> Bundle {
        guard let languageCode, !languageCode.isEmpty else { return .main }

        let normalizedCode = languageCode.replacingOccurrences(of: "_", with: "-")
        let baseCode = normalizedCode.split(separator: "-").first.map(String.init)
        for code in [normalizedCode, baseCode].compactMap({ $0 }) {
            if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }

        return .main
    }
}

struct AppLocalizedContent<Content: View>: View {
    @AppStorage(AppLocalization.selectedLanguageCodeKey) private var selectedLanguageCode: String = LanguageSettingsPage.defaultLanguageCode()
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .environment(\.locale, Locale(identifier: AppLocalization.localeIdentifier(for: selectedLanguageCode)))
    }
}

enum MainSidebarItem: String, CaseIterable, Identifiable {
    case compress
    case decompress
    case settings
    case language
    case contact
    
    var id: String { rawValue }

    var localizationKey: String {
        switch self {
        case .compress:
            return "File Compression"
        case .decompress:
            return "File Extraction"
        case .settings:
            return "Settings"
        case .language:
            return "Language"
        case .contact:
            return "Contact Us"
        }
    }
    
    var title: LocalizedStringKey {
        LocalizedStringKey(localizationKey)
    }
    
    var systemImage: String {
        switch self {
        case .compress:
            return "archivebox"
        case .decompress:
            return "archivebox.fill"
        case .settings:
            return "gearshape"
        case .language:
            return "globe"
        case .contact:
            return "envelope"
        }
    }
}

struct MainSidebarView: View {
    @Binding var selection: MainSidebarItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Bundle.main.localizedDisplayName)
                .font(.headline)
                .padding(.horizontal, 14)
                .padding(.top, 18)
                .padding(.bottom, 14)
            
            VStack(spacing: 4) {
                ForEach(MainSidebarItem.allCases) { item in
                    Button {
                        selection = item
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: item.systemImage)
                                .font(.system(size: 15, weight: .medium))
                                .frame(width: 20)
                            Text(item.title)
                                .font(.system(size: 14, weight: selection == item ? .semibold : .regular))
                            Spacer()
                        }
                        .foregroundStyle(selection == item ? Color.accentColor : Color.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(selection == item ? Color.accentColor.opacity(0.14) : Color.clear)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .frame(width: 184)
        .background(.bar)
    }
}

struct UtilityPageView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let systemImage: String
    let primaryActionTitle: LocalizedStringKey
    let primaryAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .light))
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 30, weight: .semibold))
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button(action: primaryAction) {
                Label {
                    Text(primaryActionTitle)
                } icon: {
                    Image(systemName: "arrow.right.circle")
                }
            }
            .controlSize(.large)
            
            Spacer()
        }
        .frame(maxWidth: 520, alignment: .leading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(48)
    }
}

struct ContactPageView: View {
    private let qqGroupNumber = "796870373"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Label("Contact Us", systemImage: "person.2.wave.2")
                    .font(.system(size: 28, weight: .semibold))
                
                Text("Join the QQ group to report issues, discuss features, and get support.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                Image(systemName: "number")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 44, height: 44)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.12))
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("QQ Group")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(verbatim: qqGroupNumber)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .textSelection(.enabled)
                }
                
                Spacer(minLength: 12)
            }
            .padding(18)
            .frame(maxWidth: 420, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(nsColor: .controlBackgroundColor))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.16))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 40)
        .padding(.vertical, 32)
    }
}

struct DecompressionPageView: View {
    let archives: [URL]
    @Binding var isDropTargeted: Bool
    let errorText: String?
    let isExtracting: Bool
    let displayType: (URL) -> String
    let onChooseArchive: () -> Void
    let onDropArchives: ([URL]) -> Void
    let onPreviewArchive: (URL) -> Void
    let onRemoveArchive: (URL) -> Void
    let onStartExtraction: () -> Void
    @State private var isDropZoneHovered = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("File Extraction")
                        .font(.system(size: 30, weight: .semibold))
                    Text("Click or drop archives to add them to the extraction list.")
                        .foregroundStyle(.secondary)
                }
                
                dropZone
                
                decompressionOptions
                
                if let errorText {
                    Text(errorText)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                if !archives.isEmpty {
                    decompressionList
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private var dropZone: some View {
        let isActive = isDropTargeted || isDropZoneHovered
        
        return VStack(spacing: 14) {
            Image(systemName: isDropTargeted ? "archivebox.fill" : "archivebox")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(isActive ? Color.accentColor : Color.secondary)
            
            Text(isDropTargeted ? "Drop to add to extraction list" : "Click or drop archives")
                .font(.title3.weight(.semibold))
            
            Text("Multiple archives can be added at once and removed from the list below.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Color.accentColor.opacity(0.10) : Color.secondary.opacity(0.06))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isActive ? Color.accentColor : Color.secondary.opacity(0.28),
                    style: StrokeStyle(lineWidth: 1.5, dash: [7, 5])
                )
        }
        .contentShape(Rectangle())
        .onDrop(of: ["public.file-url"], isTargeted: $isDropTargeted) { providers in
            loadDroppedArchiveURLs(from: providers)
            return true
        }
        .onTapGesture(perform: onChooseArchive)
        .onHover { isDropZoneHovered = $0 }
        .help("Click or drop archives")
    }
    
    private var decompressionOptions: some View {
        let labelWidth: CGFloat = 64
        let controlWidth: CGFloat = 160
        let detailWidth: CGFloat = 420
        let columnSpacing: CGFloat = 16
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: columnSpacing) {
                Text("Action")
                    .font(.subheadline.weight(.medium))
                    .frame(width: labelWidth, alignment: .leading)
                
                Button {
                    onStartExtraction()
                } label: {
                    Label {
                        Text(isExtracting ? AppLocalization.localizedString("Extracting") : AppLocalization.localizedString("Start Extraction"))
                    } icon: {
                        Image(systemName: "arrow.down.doc")
                    }
                }
                .controlSize(.large)
                .disabled(archives.isEmpty || isExtracting)
                .frame(width: controlWidth, alignment: .leading)
                
                if isExtracting {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView()
                            .progressViewStyle(.linear)
                        Text("Extracting, please wait")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: detailWidth, alignment: .leading)
                } else {
                    Text(archives.isEmpty ? AppLocalization.localizedString("Multiple archives can be added at once") : AppLocalization.localizedString("%lld archives added to the extraction list", archives.count))
                        .foregroundStyle(.secondary)
                        .frame(width: detailWidth, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.05))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.16), lineWidth: 1)
        }
    }
    
    private var decompressionList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Type")
                    .frame(width: 96, alignment: .leading)
                Text("Size")
                    .frame(width: 120, alignment: .trailing)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.secondary.opacity(0.06))
            
            Divider()
            
            LazyVStack(spacing: 0) {
                ForEach(archives, id: \.self) { archive in
                    DecompressionListRow(
                        url: archive,
                        typeLabel: displayType(archive),
                        onPreview: { onPreviewArchive(archive) },
                        onRemove: { onRemoveArchive(archive) }
                    )
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.22), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func loadDroppedArchiveURLs(from providers: [NSItemProvider]) {
        sidebarLog.notice("Decompression drop received", context: ["providers": "\(providers.count)"])
        let group = DispatchGroup()
        let lock = NSLock()
        var urls: [URL] = []
        
        for (index, provider) in providers.enumerated() {
            group.enter()
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                defer { group.leave() }
                
                let url: URL?
                if let itemURL = item as? URL {
                    url = itemURL
                } else if let itemURL = item as? NSURL {
                    url = itemURL as URL
                } else if let data = item as? Data {
                    url = URL(dataRepresentation: data, relativeTo: nil)
                } else {
                    url = nil
                }
                
                if let url {
                    sidebarLog.notice("Decompression drop resolved URL", context: [
                        "index": "\(index)",
                        "path": url.path
                    ])
                    lock.lock()
                    urls.append(url)
                    lock.unlock()
                } else {
                    sidebarLog.error("Decompression drop could not resolve URL", context: ["index": "\(index)"])
                }
            }
        }
        
        group.notify(queue: .main) {
            sidebarLog.notice("Decompression drop dispatching URLs", context: ["count": "\(urls.count)"])
            guard !urls.isEmpty else { return }
            onDropArchives(urls)
        }
    }
}

private struct DecompressionListRow: View {
    let url: URL
    let typeLabel: String
    let onPreview: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
                .resizable()
                .frame(width: 16, height: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: url.lastPathComponent)
                    .lineLimit(1)
                Text(verbatim: url.path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(typeLabel)
                .foregroundStyle(.secondary)
                .frame(width: 96, alignment: .leading)
            
            Text(sizeLabel)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .trailing)
            
            Button(action: onPreview) {
                Image(systemName: "eye")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .help("Preview")
            
            Button(action: onRemove) {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .help("Remove")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
    }
    
    private var sizeLabel: String {
        let size = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
        return SystemHelper.shared.format(bytes: size)
    }
}

struct CompressionPageView: View {
    let items: [ArchiveItem]
    @Binding var isDropTargeted: Bool
    @Binding var selectedFormat: CompressionArchiveFormat
    @Binding var selectedLevel: CompressionLevel
    @Binding var usePassword: Bool
    @Binding var password: String
    let passwordError: String?
    let isCompressing: Bool
    let onFormatChange: () -> Void
    let onChooseFiles: () -> Void
    let onDropFiles: ([URL]) -> Void
    let onRemoveItem: (ArchiveItem) -> Void
    let onStartCompression: () -> Void
    @State private var isDropZoneHovered = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("File Compression")
                        .font(.system(size: 30, weight: .semibold))
                    Text("Click or drop files and folders to create a new archive.")
                        .foregroundStyle(.secondary)
                }
                
                dropZone
                
                compressionOptions
                
                if !items.isEmpty {
                    compressionList
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private var compressionOptions: some View {
        let labelWidth: CGFloat = 64
        let controlWidth: CGFloat = 160
        let detailWidth: CGFloat = 420
        let columnSpacing: CGFloat = 16
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: columnSpacing) {
                Text("Archive Format")
                    .font(.subheadline.weight(.medium))
                    .frame(width: labelWidth, alignment: .leading)
                
                Picker("Archive Format", selection: $selectedFormat) {
                    ForEach(CompressionArchiveFormat.allCases) { format in
                        Text(LocalizedStringKey(format.title)).tag(format)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(width: controlWidth, alignment: .leading)
                
                Text(AppLocalization.localizedString(selectedFormat.passwordSupportText))
                    .font(.caption)
                    .foregroundStyle(selectedFormat.supportsPassword ? Color.secondary : Color.orange)
                    .frame(width: detailWidth, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: columnSpacing) {
                Text("Compression Level")
                    .font(.subheadline.weight(.medium))
                    .frame(width: labelWidth, alignment: .leading)
                
                Picker("Compression Level", selection: $selectedLevel) {
                    ForEach(CompressionLevel.allCases) { level in
                        Text(LocalizedStringKey(level.title)).tag(level)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(width: controlWidth, alignment: .leading)
                
                Text(AppLocalization.localizedString(selectedLevel.description))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: detailWidth, alignment: .leading)
            }
            
            HStack(alignment: .center, spacing: columnSpacing) {
                Text("Password")
                    .font(.subheadline.weight(.medium))
                    .frame(width: labelWidth, alignment: .leading)
                
                Toggle("", isOn: $usePassword)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .disabled(!selectedFormat.supportsPassword)
                    .frame(width: controlWidth, alignment: .leading)
                
                if usePassword {
                    SecureField("Enter password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: detailWidth, alignment: .leading)
                } else {
                    Color.clear
                        .frame(width: detailWidth, height: 1)
                }
            }
            
            HStack(alignment: .center, spacing: columnSpacing) {
                Text("Action")
                    .font(.subheadline.weight(.medium))
                    .frame(width: labelWidth, alignment: .leading)
                
                Button {
                    onStartCompression()
                } label: {
                    Label {
                        Text(isCompressing ? AppLocalization.localizedString("Compressing") : AppLocalization.localizedString("Start Compression"))
                    } icon: {
                        Image(systemName: "archivebox")
                    }
                }
                .controlSize(.large)
                .disabled(items.isEmpty || isCompressing)
                .frame(width: controlWidth, alignment: .leading)
                
                if isCompressing {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView()
                            .progressViewStyle(.linear)
                        Text("Compressing, please wait")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: detailWidth, alignment: .leading)
                } else {
                    Text(items.isEmpty ? AppLocalization.localizedString("Multiple files and folders can be added at once") : AppLocalization.localizedString("%lld items added to the compression list", items.count))
                        .foregroundStyle(.secondary)
                        .frame(width: detailWidth, alignment: .leading)
                }
            }
            
            if let passwordError {
                HStack(spacing: columnSpacing) {
                    Color.clear
                        .frame(width: labelWidth)
                    Color.clear
                        .frame(width: controlWidth)
                    Text(passwordError)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(width: detailWidth, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.05))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.16), lineWidth: 1)
        }
        .onChange(of: selectedFormat) { newValue in
            onFormatChange()
            if !newValue.supportsPassword {
                usePassword = false
                password = ""
            }
        }
    }
    
    private var dropZone: some View {
        let isActive = isDropTargeted || isDropZoneHovered
        
        return VStack(spacing: 14) {
            Image(systemName: isDropTargeted ? "arrow.down.doc.fill" : "tray.and.arrow.down")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(isActive ? Color.accentColor : Color.secondary)
            
            Text(isDropTargeted ? "Drop to add to compression list" : "Click or drop files/folders")
                .font(.title3.weight(.semibold))
            
            Text("Multiple items can be added at once and will appear in the list below.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Color.accentColor.opacity(0.10) : Color.secondary.opacity(0.06))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isActive ? Color.accentColor : Color.secondary.opacity(0.28),
                    style: StrokeStyle(lineWidth: 1.5, dash: [7, 5])
                )
        }
        .contentShape(Rectangle())
        .onDrop(of: ["public.file-url"], isTargeted: $isDropTargeted) { providers in
            loadDroppedFileURLs(from: providers)
            return true
        }
        .onTapGesture(perform: onChooseFiles)
        .onHover { isDropZoneHovered = $0 }
        .help("Click or drop files and folders")
    }
    
    private var compressionList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Type")
                    .frame(width: 96, alignment: .leading)
                Text("Size")
                    .frame(width: 120, alignment: .trailing)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.secondary.opacity(0.06))
            
            Divider()
            
            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    CompressionListRow(item: item) {
                        onRemoveItem(item)
                    }
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.22), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func loadDroppedFileURLs(from providers: [NSItemProvider]) {
        sidebarLog.notice("Compression drop received", context: ["providers": "\(providers.count)"])
        let group = DispatchGroup()
        let lock = NSLock()
        var urls: [URL] = []
        
        for (index, provider) in providers.enumerated() {
            group.enter()
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                defer { group.leave() }
                
                sidebarLog.debug("Compression drop item loaded", context: [
                    "index": "\(index)",
                    "itemType": item.map { String(describing: type(of: $0)) } ?? "nil"
                ])
                
                let url: URL?
                if let itemURL = item as? URL {
                    url = itemURL
                } else if let itemURL = item as? NSURL {
                    url = itemURL as URL
                } else if let data = item as? Data {
                    url = URL(dataRepresentation: data, relativeTo: nil)
                } else {
                    url = nil
                }
                
                if let url {
                    sidebarLog.notice("Compression drop resolved URL", context: [
                        "index": "\(index)",
                        "path": url.path
                    ])
                    lock.lock()
                    urls.append(url)
                    lock.unlock()
                } else {
                    sidebarLog.error("Compression drop could not resolve URL", context: ["index": "\(index)"])
                }
            }
        }
        
        group.notify(queue: .main) {
            sidebarLog.notice("Compression drop dispatching URLs", context: ["count": "\(urls.count)"])
            guard !urls.isEmpty else { return }
            onDropFiles(urls)
        }
    }
}

private struct CompressionListRow: View {
    let item: ArchiveItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(nsImage: icon)
                .resizable()
                .frame(width: 16, height: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: item.name)
                    .lineLimit(1)
                Text(verbatim: item.url?.path ?? item.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(typeLabel)
                .foregroundStyle(.secondary)
                .frame(width: 96, alignment: .leading)
            
            Text(sizeLabel)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .trailing)
            
            Button(action: onRemove) {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .help("Remove")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
    }
    
    private var icon: NSImage {
        if item.type == .directory {
            return NSWorkspace.shared.icon(for: .folder)
        }
        let contentType = UTType(filenameExtension: item.ext) ?? .data
        return NSWorkspace.shared.icon(for: contentType)
    }
    
    private var typeLabel: String {
        switch item.type {
        case .directory:
            return AppLocalization.localizedString("Folder")
        case .file:
            return item.ext.isEmpty ? AppLocalization.localizedString("File") : item.ext.uppercased()
        default:
            return AppLocalization.localizedString("Item")
        }
    }
    
    private var sizeLabel: String {
        let displaySize = item.uncompressedSize > 0 ? item.uncompressedSize : item.compressedSize
        return item.type == .directory ? "-" : SystemHelper.shared.format(bytes: displaySize)
    }
}

private struct LanguageOption: Identifiable {
    let code: String
    let nativeName: String
    let displayName: String
    
    var id: String { code }
}

struct LanguageSettingsPage: View {
    @AppStorage(AppLocalization.selectedLanguageCodeKey) private var selectedLanguageCode: String = LanguageSettingsPage.defaultLanguageCode()
    
    private static let languages: [LanguageOption] = [
        LanguageOption(code: "en", nativeName: "English", displayName: "English"),
        LanguageOption(code: "zh-Hans", nativeName: "简体中文", displayName: "Simplified Chinese"),
        LanguageOption(code: "de", nativeName: "Deutsch", displayName: "German"),
        LanguageOption(code: "es-MX", nativeName: "Español (México)", displayName: "Mexican Spanish"),
        LanguageOption(code: "fa", nativeName: "فارسی", displayName: "Persian"),
        LanguageOption(code: "fr", nativeName: "Français", displayName: "French"),
        LanguageOption(code: "it", nativeName: "Italiano", displayName: "Italian"),
        LanguageOption(code: "ja", nativeName: "日本語", displayName: "Japanese"),
        LanguageOption(code: "ko", nativeName: "한국어", displayName: "Korean"),
        LanguageOption(code: "pl", nativeName: "Polski", displayName: "Polish"),
        LanguageOption(code: "pt-BR", nativeName: "Português", displayName: "Brazilian Portuguese"),
        LanguageOption(code: "ru", nativeName: "Русский", displayName: "Russian"),
        LanguageOption(code: "uk", nativeName: "Українська", displayName: "Ukrainian")
    ]
    
    private let columns = [
        GridItem(.adaptive(minimum: 184, maximum: 260), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    ForEach(Self.languages) { language in
                        languageButton(for: language)
                    }
                }
            }
            .frame(maxWidth: 760, alignment: .leading)
            .padding(32)
        }
        .frame(minWidth: 640, maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: syncInitialLanguageSelection)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Language", systemImage: "globe")
                .font(.system(size: 28, weight: .semibold))
            
            Text(AppLocalization.localizedString("New language settings take effect after reopening the app. System default: %@", systemLanguageName))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func languageButton(for language: LanguageOption) -> some View {
        let isSelected = selectedLanguageCode == language.code
        
        return Button {
            select(language)
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: language.nativeName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(verbatim: language.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer(minLength: 8)
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary.opacity(0.55))
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : Color(nsColor: .controlBackgroundColor))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor.opacity(0.75) : Color.secondary.opacity(0.16), lineWidth: isSelected ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var systemLanguageName: String {
        let code = Self.defaultLanguageCode()
        return Self.languages.first { $0.code == code }?.nativeName ?? "English"
    }
    
    private func select(_ language: LanguageOption) {
        guard selectedLanguageCode != language.code else { return }
        selectedLanguageCode = language.code
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        showRestartNotice()
    }
    
    private func syncInitialLanguageSelection() {
        if UserDefaults.standard.object(forKey: "selectedLanguageCode") == nil ||
            Self.languages.contains(where: { $0.code == selectedLanguageCode }) == false {
            selectedLanguageCode = Self.defaultLanguageCode()
        }
    }
    
    static func defaultLanguageCode() -> String {
        for identifier in Locale.preferredLanguages {
            if let code = supportedLanguageCode(for: identifier) {
                return code
            }
        }
        
        return "en"
    }
    
    private static func supportedLanguageCode(for identifier: String) -> String? {
        let normalizedIdentifier = identifier.replacingOccurrences(of: "_", with: "-")
        
        if let exactMatch = languages.first(where: { $0.code == normalizedIdentifier }) {
            return exactMatch.code
        }
        
        if let prefixMatch = languages.first(where: { normalizedIdentifier.hasPrefix("\($0.code)-") }) {
            return prefixMatch.code
        }
        
        if ["zh-CN", "zh-SG", "zh-Hans"].contains(where: { normalizedIdentifier.hasPrefix($0) }) {
            return "zh-Hans"
        }
        
        guard let baseLanguage = normalizedIdentifier.split(separator: "-").first.map(String.init) else {
            return nil
        }
        
        return languages.first { $0.code == baseLanguage }?.code
    }
    
    private func showRestartNotice() {
        let alert = NSAlert()
        alert.messageText = AppLocalization.localizedString("Language will change after restart")
        alert.informativeText = AppLocalization.localizedString("Please reopen %@ to apply the new language setting.", Bundle.main.localizedDisplayName)
        alert.runModal()
    }
}
