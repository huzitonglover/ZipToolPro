//
//  ArchiveView.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation
import QuickLook
import Core
import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject private var state: ArchiveState
    
    @AppStorage(Keys.showColumnUncompressedSize) var showUncompressedSize: Bool = true
    @AppStorage(Keys.showColumnModificationDate) var showModificationDate: Bool = true
    @AppStorage(Keys.showColumnPosixPermissions) var showPermissions: Bool = false
    
    @State private var isDraggingOver = false
    @State private var selection: IndexSet?
    @State private var loading: Bool = false
    
    var body: some View {
        VStack {
            ArchiveTableViewRepresentable(
                selection: $selection,
                isReloadNeeded: $state.isReloadNeeded,
                showUncompressedSizeColumn: $showUncompressedSize,
                showModificationDateColumn: $showModificationDate,
                showPosixPermissionsColumn: $showPermissions
            )
        }
        .border(isDraggingOver ? Color.blue : Color.clear, width: 2)
        .onDrop(of: ["public.file-url"], isTargeted: $isDraggingOver) { providers -> Bool in
            for provider in providers {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (data, error) in
                    if let data = data as? Data,
                       let fileURL = URL(dataRepresentation: data, relativeTo: nil) {
                        DispatchQueue.main.async {
                            Task {
                                await self.drop(fileURL)
                            }
                        }
                    }
                }
            }
            return true
        }
        .onAppear {
            if state.openWithUrls.count > 0 {
                Task {
                    await self.drop(state.openWithUrls[0])
                }
            }
        }
        .quickLookPreview($state.previewItemUrl)
    }
    
    //
    // functions
    //
    
    func drop(_ url: URL) async {
        // We have to distinguish 3 cases here.
        // 1. No archive loaded > Check if archive,
        // 1.1. if yes, load.
        // 2.2. If no, create new archive and add the dropped file as first entry
        // 2. Archive loaded > Add file to current archive
        if state.hasArchive == false {
            if state.isSupportedArchive(url: url) {
                state.clean()
                state.open(url: url)
            } else {
                state.create()
                state.add(url: url)
            }
        } else {
            // add to current archive
            state.add(url: url)
        }
    }
}
