//
//  AdvancedSettingsView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation
import SwiftUI
import tb

struct AdvancedSettingsView: View {
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    @State private var statusText: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Advanced")
                    .font(.headline)
                
                actionRow(
                    title: "Export Logs",
                    description: "Save recent app logs as an NDJSON file.",
                    systemImage: "square.and.arrow.up",
                    buttonTitle: "Export"
                ) {
                    exportLogs()
                }
                
                actionRow(
                    title: "Open Cache Folder",
                    description: cacheDirectory?.path ?? AppLocalization.localizedString("Cache folder unavailable."),
                    systemImage: "folder",
                    buttonTitle: "Open"
                ) {
                    openCacheDirectory()
                }
                .disabled(cacheDirectory == nil)
                
                actionRow(
                    title: "Clear Cache",
                    description: "Remove temporary files created for previews and extraction.",
                    systemImage: "trash",
                    buttonTitle: "Clear"
                ) {
                    clearCache()
                }
                .disabled(cacheDirectory == nil)
            }
            
            if let statusText {
                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private func actionRow(
        title: LocalizedStringKey,
        description: String,
        systemImage: String,
        buttonTitle: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            Button(buttonTitle, action: action)
        }
        .padding(10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
    }
    
    private func openCacheDirectory() {
        guard let url = cacheDirectory else { return }
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
        statusText = AppLocalization.localizedString("Cache folder opened.")
    }
    
    private func clearCache() {
        CacheCleaner().clean()
        statusText = AppLocalization.localizedString("Cache cleared.")
    }
    
    private func exportLogs() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "\(Bundle.main.localizedDisplayName)-logs.ndjson"
        panel.canCreateDirectories = true
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try tb.exportRecentLogs(since: Date(timeIntervalSinceNow: -60 * 60), to: url)
            NSWorkspace.shared.activateFileViewerSelecting([url])
            statusText = AppLocalization.localizedString("Logs exported to %@.", url.lastPathComponent)
        } catch {
            let alert = NSAlert()
            alert.messageText = AppLocalization.localizedString("Export Failed")
            alert.informativeText = error.localizedDescription
            alert.runModal()
            statusText = AppLocalization.localizedString("Log export failed.")
        }
    }
}
