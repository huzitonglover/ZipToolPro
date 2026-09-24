//
//  ContentView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import AppKit
import Core
import SwiftUI
import tb

private let contentLog = tb.Logger(subsystem: "app.ZipToolPro", category: "archive")

private struct PasswordSheetRequest: Identifiable {
    let id = UUID()
    let request: ArchivePasswordRequest
}

struct ContentView: View {
    // settings
    @AppStorage(Keys.settingBreadcrumbPosition) var breadcrumbPosition: BreadcrumbPosition = .bottom
    
    // environment
    @EnvironmentObject var archiveState: ArchiveState
    @EnvironmentObject var appState: AppState
    
    @State private var passwordContinuation: CheckedContinuation<String?, Never>?
    @State private var passwordSheetRequest: PasswordSheetRequest?
    @State private var compressionDropIsTargeted: Bool = false
    @State private var decompressionDropIsTargeted: Bool = false
    @State private var compressionFormat: CompressionArchiveFormat = .zip
    @State private var compressionLevel: CompressionLevel = .standard
    @State private var compressionUsesPassword: Bool = false
    @State private var compressionPassword: String = ""
    @State private var compressionPasswordError: String?
    @State private var compressionIsRunning: Bool = false
    @State private var decompressionArchives: [URL] = []
    @State private var previewedDecompressionArchive: URL?
    @State private var decompressionError: String?
    @State private var decompressionIsRunning: Bool = false
    @AppStorage(AppLocalization.selectedLanguageCodeKey) private var selectedLanguageCode: String = LanguageSettingsPage.defaultLanguageCode()
    
    var body: some View {
        HStack(spacing: 0) {
            MainSidebarView(selection: $appState.selectedSidebarItem)
            
            Divider()
            
            selectedContent
        }
        .onChange(of: archiveState.compressionResult) { result in
            guard let result else { return }
            compressionIsRunning = false
            if let destination = result.destination {
                showCompressionFinishedAlert(url: destination)
            } else if let errorMessage = result.errorMessage {
                compressionPasswordError = AppLocalization.localizedString("Compression failed: %@", localizedArchiveError(errorMessage))
            }
        }
        .onChange(of: archiveState.decompressionResult) { result in
            guard let result else { return }
            decompressionIsRunning = false
            if let destination = result.destination {
                showDecompressionFinishedAlert(url: destination, archiveCount: result.archiveCount)
                decompressionArchives.removeAll()
                previewedDecompressionArchive = nil
            } else if let errorMessage = result.errorMessage {
                decompressionError = AppLocalization.localizedString("Extraction failed: %@", localizedArchiveError(errorMessage))
            }
        }
        .onChange(of: archiveState.url) { url in
            guard let url, archiveState.isSupportedArchive(url: url) else { return }
            addArchivesForDecompression([url])
        }
        .onAppear {
            if self.archiveState.passwordProvider == nil {
                let passwordProvider: ArchivePasswordUserProvider = { request in
                    
                    await withCheckedContinuation { continuation in
                        Task { @MainActor in
                            self.passwordContinuation = continuation
                            self.passwordSheetRequest = PasswordSheetRequest(request: request)
                        }
                    }
                }
                
                self.archiveState.passwordProvider = passwordProvider
            }
        }
        .sheet(item: $passwordSheetRequest, onDismiss: cancelPasswordRequest) { sheetRequest in
            PasswordView(
                request: sheetRequest.request,
                onSubmit: { password in
                    passwordContinuation?.resume(returning: password)
                    passwordContinuation = nil
                    passwordSheetRequest = nil
                },
                onCancel: {
                    passwordContinuation?.resume(returning: nil)
                    passwordContinuation = nil
                    passwordSheetRequest = nil
                }
            )
            .frame(width: 440)
        }
        .navigationTitle(navigationTitle)
        .navigationSubtitle(navigationSubtitle)
        .environmentObject(archiveState)
    }
    
    @ViewBuilder
    private var selectedContent: some View {
        switch appState.selectedSidebarItem {
        case .compress:
            CompressionPageView(
                items: archiveState.childItems ?? [],
                isDropTargeted: $compressionDropIsTargeted,
                selectedFormat: $compressionFormat,
                selectedLevel: $compressionLevel,
                usePassword: $compressionUsesPassword,
                password: $compressionPassword,
                passwordError: compressionPasswordError,
                isCompressing: compressionIsRunning,
                onFormatChange: {
                    compressionPasswordError = nil
                    if archiveState.childItems?.isEmpty == false {
                        archiveState.ensureCompressionDraft()
                    }
                },
                onChooseFiles: startCompression,
                onDropFiles: addFilesForCompression,
                onRemoveItem: archiveState.removeAddedItem,
                onStartCompression: saveCompressedArchive
            )
        case .decompress:
            archiveContent
        case .settings:
            SettingsView()
        case .language:
            LanguageSettingsPage()
        case .contact:
            ContactPageView()
        }
    }
    
    private var archiveContent: some View {
        VStack(spacing: 0) {
            if let previewedDecompressionArchive,
               archiveState.url == previewedDecompressionArchive {
                decompressionPreviewContent(for: previewedDecompressionArchive)
            } else {
                DecompressionPageView(
                    archives: decompressionArchives,
                    isDropTargeted: $decompressionDropIsTargeted,
                    errorText: decompressionError,
                    isExtracting: decompressionIsRunning,
                    displayType: archiveState.archiveDisplayType(for:),
                    onChooseArchive: startDecompression,
                    onDropArchives: addArchivesForDecompression,
                    onPreviewArchive: previewArchiveForDecompression,
                    onRemoveArchive: removeArchiveForDecompression,
                    onStartExtraction: startBatchDecompression
                )
            }
        }
    }
    
    private func decompressionPreviewContent(for url: URL) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button {
                    previewedDecompressionArchive = nil
                } label: {
                    Label("Back to List", systemImage: "chevron.left")
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: url.lastPathComponent)
                        .font(.headline)
                    Text(verbatim: url.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            
            Divider()
                .frame(height: 1)
                .background(.quinary)
            
            if breadcrumbPosition == .top {
                if let selectedItem = archiveState.selectedItem {
                    BreadcrumbView(for: selectedItem)
                }
                
                Divider()
                    .frame(height: 1)
                    .background(.quinary)
            }
            
            ArchiveView()
            
            if breadcrumbPosition == .bottom {
                if let selectedItem = archiveState.selectedItem {
                    Divider()
                        .frame(height: 1)
                        .background(.quinary)
                    
                    BreadcrumbView(for: selectedItem)
                }
            }
            
            Divider()
                .frame(height: 1)
                .background(.quinary)
            
            StatusBarView()
        }
    }
    
    private var navigationTitle: String {
        if appState.selectedSidebarItem == .decompress,
           previewedDecompressionArchive != nil,
           let name = archiveState.name {
            return name
        }

        return AppLocalization.localizedString(appState.selectedSidebarItem.localizationKey)
    }
    
    private var navigationSubtitle: Text {
        if appState.selectedSidebarItem == .decompress,
           previewedDecompressionArchive != nil,
           let url = archiveState.url {
            return Text(verbatim: url.path)
        }
        
        return Text(verbatim: "")
    }

    private func localizedArchiveError(_ message: String) -> String {
        let emptyArchivePrefix = "The archive has no extractable content: "
        if message.hasPrefix(emptyArchivePrefix) {
            let archiveName = String(message.dropFirst(emptyArchivePrefix.count))
            return AppLocalization.localizedString("The archive has no extractable content: %@", archiveName)
        }

        return AppLocalization.localizedString(message)
    }
    
    private func startCompression() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.data, .folder]
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.begin { response in
            guard response == .OK else { return }
            addFilesForCompression(panel.urls)
        }
    }

    private func cancelPasswordRequest() {
        passwordContinuation?.resume(returning: nil)
        passwordContinuation = nil
        passwordSheetRequest = nil
    }
    
    private func addFilesForCompression(_ urls: [URL]) {
        compressionPasswordError = nil
        contentLog.notice("Compression add requested", context: [
            "count": "\(urls.count)",
            "hasArchive": "\(archiveState.hasArchive)",
            "canBeEdited": "\(archiveState.canBeEdited)",
            "hasSelectedItem": "\(archiveState.selectedItem != nil)"
        ])
        guard !urls.isEmpty else {
            contentLog.notice("Compression add skipped: no URLs")
            return
        }
        archiveState.ensureCompressionDraft()
        contentLog.notice("Compression draft ensured", context: [
            "hasArchive": "\(archiveState.hasArchive)",
            "canBeEdited": "\(archiveState.canBeEdited)",
            "hasSelectedItem": "\(archiveState.selectedItem != nil)"
        ])
        for url in urls {
            contentLog.notice("Compression adding URL", context: ["path": url.path])
            archiveState.add(url: url)
        }
        contentLog.notice("Compression add finished", context: [
            "childItems": "\(archiveState.childItems?.count ?? -1)",
            "diff": "\(archiveState.diff.count)"
        ])
    }
    
    private func saveCompressedArchive() {
        compressionPasswordError = nil
        if compressionUsesPassword && compressionPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            compressionPasswordError = AppLocalization.localizedString("Enter password")
            return
        }
        if !compressionFormat.supportsPassword && compressionUsesPassword {
            compressionPasswordError = AppLocalization.localizedString("%@ does not support passwords", compressionFormat.title)
            return
        }
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "Archive.\(compressionFormat.fileExtension)"
        panel.allowedContentTypes = [.data]
        panel.canCreateDirectories = true
        panel.begin { response in
            guard response == .OK, var destination = panel.url else { return }
            compressionIsRunning = true
            
            if destination.pathExtension.lowercased() != compressionFormat.fileExtension {
                destination.deletePathExtension()
                destination.appendPathExtension(compressionFormat.fileExtension)
            }
            
            DispatchQueue.main.async {
                archiveState.save(
                    to: destination,
                    format: compressionFormat,
                    level: compressionLevel,
                    password: compressionUsesPassword ? compressionPassword : nil
                )
            }
        }
    }
    
    private func showCompressionFinishedAlert(url: URL) {
        let alert = NSAlert()
        alert.messageText = AppLocalization.localizedString("Compression Complete")
        alert.informativeText = AppLocalization.localizedString("The archive was saved to: %@", url.path)
        alert.alertStyle = .informational
        alert.addButton(withTitle: AppLocalization.localizedString("OK"))
        alert.runModal()
    }
    
    private func startDecompression() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.data]
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.begin { response in
            guard response == .OK else { return }
            addArchivesForDecompression(panel.urls)
        }
    }
    
    private func addArchivesForDecompression(_ urls: [URL]) {
        decompressionError = nil
        let supportedURLs = urls.filter { archiveState.isSupportedArchive(url: $0) }
        guard supportedURLs.count == urls.count else {
            decompressionError = AppLocalization.localizedString("Please select supported archive files")
            return
        }
        
        for url in supportedURLs where !decompressionArchives.contains(url) {
            decompressionArchives.append(url)
        }
        appState.selectedSidebarItem = .decompress
    }
    
    private func removeArchiveForDecompression(_ url: URL) {
        decompressionArchives.removeAll { $0 == url }
        if previewedDecompressionArchive == url {
            previewedDecompressionArchive = nil
        }
        if decompressionArchives.isEmpty {
            decompressionError = nil
        }
    }
    
    private func previewArchiveForDecompression(_ url: URL) {
        addArchivesForDecompression([url])
        previewedDecompressionArchive = url
        archiveState.open(url: url)
    }
    
    private func startBatchDecompression() {
        decompressionError = nil
        guard !decompressionArchives.isEmpty else { return }
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = AppLocalization.localizedString("Extract Here")
        panel.begin { response in
            guard response == .OK, let destination = panel.url else { return }
            decompressionIsRunning = true
            archiveState.extractArchives(decompressionArchives, to: destination)
        }
    }
    
    private func showDecompressionFinishedAlert(url: URL, archiveCount: Int) {
        let alert = NSAlert()
        alert.messageText = AppLocalization.localizedString("Extraction Complete")
        alert.informativeText = AppLocalization.localizedString("%lld archives extracted to: %@", archiveCount, url.path)
        alert.alertStyle = .informational
        alert.addButton(withTitle: AppLocalization.localizedString("OK"))
        alert.runModal()
    }
    
}
