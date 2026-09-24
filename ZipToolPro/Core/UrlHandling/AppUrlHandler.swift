//
//  AppUrlHandler.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import Foundation
import AppKit

private enum AccessTargetKind {
    case file
    case directory
}

@MainActor
protocol AppUrlHandler {
    func handle(appUrl: AppUrl, archiveWindowManager: ArchiveWindowManager)
}

extension AppUrlHandler {
    private func requestAccess(
        for fileUrl: URL,
        targetKind: AccessTargetKind,
        completion: @escaping (NSApplication.ModalResponse, URL?) -> Void
    ) {
        let appName = Bundle.main.localizedDisplayName
        let message = "\(appName) needs access to \(fileUrl.lastPathComponent)"
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = targetKind == .file
        openPanel.canChooseDirectories = targetKind == .directory
        openPanel.allowsOtherFileTypes = false
        openPanel.prompt = "Give access to \(appName)"
        openPanel.message = message
        openPanel.directoryURL = fileUrl
        openPanel.level = .floating
        openPanel.begin() { response in
            completion(response, openPanel.url)
        }
    }
    
    func requestAccessToFile(
        for fileUrl: URL,
        completion: @escaping (NSApplication.ModalResponse, URL?) -> Void
    ) {
        requestAccess(
            for: fileUrl,
            targetKind: .file,
            completion: completion
        )
    }
    
    func requestAccessToDir(
        for fileUrl: URL,
        completion: @escaping (NSApplication.ModalResponse, URL?) -> Void
    ) {
        requestAccess(
            for: fileUrl,
            targetKind: .directory,
            completion: completion
        )
    }
}
