//
//  StatusBarView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import SwiftUI

struct StatusBarView: View {
    @EnvironmentObject var archiveState: ArchiveState
    
    var typeName: String? {
        if let comp = archiveState.compositionType {
            return comp.name
        }
        if let type = archiveState.type {
            return type.name
        }
        return nil
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if archiveState.hasArchive {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    if archiveState.isBusy {
                        CancelEngineActionButtonView() {
                            archiveState.cancelCurrentOperation()
                        }
                        
                        ProgressView()
                            .scaleEffect(0.4)
                            .frame(height: 14)
                            .progressViewStyle(.circular)
                        
                        Text(verbatim: "\(archiveState.statusText ?? "")")
                        
                        if let progress = archiveState.progress {
                            Text(verbatim: "\(progress)%")
                                .padding(.leading, 4)
                        }
                        
                        Spacer()
                    } else {
                        Text("\(archiveState.entries.count) items")
                        if let uncompressedSize = archiveState.uncompressedSize {
                            Text(verbatim: " • \(SystemHelper.shared.format(bytes: uncompressedSize))")
                        }
                        
                        Spacer()
                        
                        if archiveState.selectedItems.count == 0 {
                            Text(verbatim: "\(typeName ?? "")")
                            if let isEncrypted = archiveState.isEncrypted, isEncrypted {
                                Text(verbatim: " • ")
                                Image(systemName: "lock.fill")
                            }
                        } else {
                            Text("\(archiveState.selectedItems.count) selected")
                            Text(verbatim: " • ")
                            Text(verbatim: "\(SystemHelper.shared.format(bytes: archiveState.selectedItems.reduce(into: 0) { $0 += $1.uncompressedSize }))")
                        }
                    }
                }
                .font(.subheadline.weight(.light))
                .foregroundStyle(.secondary)
            }
        }
        .padding(.windowSafeHorizontal)
        .frame(height: 27)
    }
}
