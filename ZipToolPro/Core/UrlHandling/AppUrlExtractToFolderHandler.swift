//
//  AppUrlExtractToFolderHandler.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation
import Core
import tb

private let log = tb.Logger(subsystem: "app.ZipToolPro", category: "url")

class AppUrlExtractToFolderHandler: AppUrlHandler {
    private let catalog: ArchiveTypeCatalog
    private let engineSelector: ArchiveEngineSelectorProtocol
    
    init(catalog: ArchiveTypeCatalog, engineSelector: ArchiveEngineSelectorProtocol) {
        self.catalog = catalog
        self.engineSelector = engineSelector
    }
    
    func handle(appUrl: AppUrl, archiveWindowManager: ArchiveWindowManager) {
        for fileUrl in appUrl.files {
            log.debug("Extracting \(fileUrl) to folder \(appUrl.target)")
            
            requestAccessToDir(for: appUrl.target) { response, url in
                if response == .OK {
                    if let url {
                        let folderName = ArchiveTypeDetector(catalog: self.catalog).getNameWithoutExtension(for: url)
                        let folderUrl = url.appendingPathComponent(folderName)
                        do {
                            try FileManager.default.createDirectory(
                                at: folderUrl,
                                withIntermediateDirectories: true
                            )
                            
                            log.debug("Found archive handler for \(fileUrl.lastPathComponent)")
                            
                            Task {
                                let state = ArchiveState(catalog: self.catalog, engineSelector: self.engineSelector)
                                state.open(url: fileUrl)
                                try await state.openTask?.value
                                state.extract(to: folderUrl)
                            }
                        } catch {
                            log.error(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
