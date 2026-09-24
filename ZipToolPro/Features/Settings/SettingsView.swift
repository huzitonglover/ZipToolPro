//
//  PreferencesView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import Foundation
import SwiftUI

private struct SupportedFormatRow: Identifiable {
    let id: String
    let name: String
    let extensions: String
}

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    
    @State private var compressionRows: [SupportedFormatRow] = []
    @State private var decompressionRows: [SupportedFormatRow] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AdvancedSettingsView()
                    .padding(0)
                
                Divider()
                
                formatSection(
                    title: "Supported Compression Formats",
                    systemImage: "archivebox",
                    rows: compressionRows
                )
                
                formatSection(
                    title: "Supported Extraction Formats",
                    systemImage: "arrow.down.doc",
                    rows: decompressionRows
                )
            }
            .padding()
        }
        .frame(minWidth: 640, maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            refreshSupportedFormats()
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
    
    private func formatSection(
        title: LocalizedStringKey,
        systemImage: String,
        rows: [SupportedFormatRow]
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                
                Spacer()
                
                Text(AppLocalization.localizedString("%lld formats", rows.count))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Format")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 180, alignment: .leading)
                    
                    Text("Extensions")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.quaternary)
                
                ForEach(rows) { row in
                    Divider()
                    
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text(row.name)
                            .font(.subheadline.weight(.medium))
                            .frame(width: 180, alignment: .leading)
                        
                        Text(row.extensions)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.quaternary)
            }
        }
    }
    
    private func refreshSupportedFormats() {
        compressionRows = CompressionArchiveFormat.allCases.map {
            SupportedFormatRow(
                id: "compression-\($0.id)",
                name: $0.title,
                extensions: ".\($0.fileExtension)"
            )
        }
        .sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        
        var rows: [SupportedFormatRow] = []
        for type in appState.catalog.getAllTypes()
        where type.engines.contains(where: { $0.capabilities.contains("extractFiles") }) {
            rows.append(
                SupportedFormatRow(
                    id: "decompression-\(type.id)",
                    name: type.name,
                    extensions: type.extensions.map { ".\($0)" }.joined(separator: ", ")
                )
            )
        }
        
        for composition in appState.catalog.allCompositions() {
            rows.append(
                SupportedFormatRow(
                    id: "decompression-\(composition.id)",
                    name: composition.name,
                    extensions: composition.extensions.map { ".\($0)" }.joined(separator: ", ")
                )
            )
        }
        
        decompressionRows = rows.sorted {
            return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}

#Preview {
    SettingsView()
}
