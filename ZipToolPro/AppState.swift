//
//  AppState.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import SwiftUI
import tb

private let log = tb.Logger(subsystem: "app.ZipToolPro", category: "lifecycle")

final class AppState: ObservableObject {
    let catalog: ArchiveTypeCatalog = ArchiveTypeCatalog()
    let engineSelector: ArchiveEngineSelectorProtocol
    let archiveEngineConfigStore: ArchiveEngineConfigStore
    @Published var selectedSidebarItem: MainSidebarItem = .decompress
    
    init() {
        self.archiveEngineConfigStore = ArchiveEngineConfigStore(catalog: catalog)
        self.engineSelector = ArchiveEngineSelector(catalog: catalog, configStore: archiveEngineConfigStore)

        log.notice("AppState ready (catalog + engine selector initialised)")
    }
}
