//
//  AppUrlExtractHereHandler.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Core
import tb

private let log = tb.Logger(subsystem: "app.ZipToolPro", category: "url")

class AppUrlExtractHereHandler: AppUrlHandler {
    private let catalog: ArchiveTypeCatalog
    private let engineSelector: ArchiveEngineSelectorProtocol
    
    init(catalog: ArchiveTypeCatalog, engineSelector: ArchiveEngineSelectorProtocol) {
        self.catalog = catalog
        self.engineSelector = engineSelector
    }
    
    func handle(appUrl: AppUrl, archiveWindowManager: ArchiveWindowManager) {
        for fileUrl in appUrl.files {
            log.debug("Extracting \(fileUrl) here... \(appUrl.target)")
            
            requestAccessToDir(for: appUrl.target) { response, url in
                if response == .OK {
                    log.debug("Found archive handler for \(fileUrl.lastPathComponent)")
                    if let url {
                        Task {
                            let state = ArchiveState(catalog: self.catalog, engineSelector: self.engineSelector)
                            state.open(url: fileUrl)
                            try await state.openTask?.value
                            state.extract(to: url)
                        }
                    }
                }
            }
        }
    }
}
