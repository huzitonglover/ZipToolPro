//
//  ArchiveContentToolbarView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import AppKit
import SwiftUI

struct ArchiveContentToolbarView: ToolbarContent {
    @State private var isExportingItem: Bool = false
    @State private var isExportingAll: Bool = false
    
    let archiveState: ArchiveState
    let contentService: ArchiveContentService = ArchiveContentService()
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                archiveState.save()
            } label: {
                Label {
                    Text("Add", comment: "Button in the tooblar that allows the user to add a file to the current archive path.")
                } icon: {
                    Image(systemName: "plus")
                }
            }
            .disabled(!archiveState.canBeEdited)
            
            Button {
                archiveState.save()
            } label: {
                Label {
                    Text("Save", comment: "Button in the tooblar that allows the user to save the current file after it was being edited.")
                } icon: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            .disabled(!archiveState.canBeEdited)
            
            Spacer()
            
            Button {
                archiveState.updateSelectedItemForQuickLook()
            } label: {
                Label {
                    Text("Preview", comment: "Button in the tooblar that allows the user to preview the selected file.")
                } icon: {
                    Image("custom.document.badge.eye")
                }
            }
            .help("Quick Look")
            
            Button {
                isExportingItem.toggle()
            } label: {
                Label {
                    Text("Extract selected", comment: "Button in the tooblar that allows the user to extract the selected files.")
                } icon: {
                    Image("custom.document.badge.arrow.down")
                }
            }
            .help("Extract selected")
            .fileImporter(
                isPresented: $isExportingItem,
                allowedContentTypes: [.folder],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result,
                   let folderURL = urls.first {
                        archiveState.extract(
                            items: archiveState.selectedItems,
                            to: folderURL)
                }
            }
            
            Button {
                isExportingAll.toggle()
            } label: {
                Label {
                    Text("Extract archive", comment: "Button in the toolbar that allows the user to extract the full archive to a target directory.")
                } icon: {
                    Image("custom.shippingbox.badge.arrow.down")
                }
            }
            .help("Extract archive")
            .fileImporter(
                isPresented: $isExportingAll,
                allowedContentTypes: [.folder],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result,
                   let folderURL = urls.first {
                        archiveState.extract(
                            to: folderURL)
                }
            }
            
            Spacer()
            
            Menu {
                Button {
                    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                } label: {
                    Label {
                        Text("Settings...", comment: "Used to open the settings/preferences window")
                    } icon: {
                        Image(systemName: "gear")
                    }
                    .labelStyle(.titleAndIcon)
                }
                
                Divider()
                
                Button {
                    if let url = archiveState.url {
                        contentService.openGetInfoWnd(for: [url])
                    }
                } label: {
                    Label {
                        Text("Archive info", comment: "Used to open Quick Look feature for the current archive file")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .labelStyle(.titleAndIcon)
                }
            } label: {
                Label {
                    Text("More", comment: "The 'More' menu in the archive window")
                } icon: {
                    Image(systemName: "ellipsis")
                }
            }
            .menuIndicator(.hidden)
            
        }
    }
}
