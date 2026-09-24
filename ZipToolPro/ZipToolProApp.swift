//
//  ZipToolProApp.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import FinderSync
import Core
import SwiftUI
import tb

private let log = tb.Logger(subsystem: "app.ZipToolPro", category: "lifecycle")

@main
struct ZipToolProApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        tb.start()
        log.notice("ZipToolProApp.init — app process starting")
    }
    
    var body: some Scene {
        Settings {
            AppLocalizedContent {
                SettingsView()
                    .environmentObject(appDelegate.appState)
            }
        }
        .commands {
            CommandGroup(replacing: .toolbar) { }
            CommandGroup(replacing: .sidebar) { }
            CommandGroup(replacing: .help) { }
        }
    }
}
