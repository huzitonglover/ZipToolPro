//
//  AppDelegate.swift
//  ZipToolPro
//
//  Created by 小胖 on 2026/5/20.
//

import AppKit
import Core
import Foundation
import SwiftUI
import tb

private let log = tb.Logger(subsystem: "app.ZipToolPro", category: "lifecycle")

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, ObservableObject {
    @AppStorage(Keys.quitOnLastWindowClosed) var quitOnLastWindowClosed: Bool = false
    private var archiveWindowManager: ArchiveWindowManager? = nil
    private var pendingOpenURLs: [URL] = []
    private var managedWindowMenu: NSMenu? = nil
    private let newWindowMenuItemTag = 1000
    private let showMainWindowMenuItemTag = 1001
    
    private static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    let appState: AppState
    
    override init() {
        if let selectedLanguageCode = UserDefaults.standard.string(forKey: AppLocalization.selectedLanguageCodeKey),
           selectedLanguageCode.isEmpty == false {
            UserDefaults.standard.set([selectedLanguageCode], forKey: "AppleLanguages")
        }

        log.notice("AppDelegate.init starting")
        appState = AppState()
        
        super.init()
        log.notice("AppDelegate.init complete — appState ready")
    }

    public func applicationWillFinishLaunching(_ notification: Notification) {
        guard !Self.isRunningInPreview else { return }
        log.notice("applicationWillFinishLaunching")
    }
    
    public func application(_ application: NSApplication, open urls: [URL]) {
        log.notice("application(open:) received \(urls.count) url(s)", context: ["first": urls.first?.lastPathComponent ?? "-", "windowManagerReady": "\(archiveWindowManager != nil)"])

        // On a cold start the open event can arrive before applicationDidFinishLaunching
        // has created the window manager. Queue the urls and replay them once we're ready.
        guard archiveWindowManager != nil else {
            log.notice("Window manager not ready yet — queuing \(urls.count) url(s) until launch finishes")
            pendingOpenURLs.append(contentsOf: urls)
            return
        }

        // first check if this is an app url, and handle it accordingly
        if let url = urls.first,
           let appUrl: AppUrl = UrlParser().parse(appUrl: url) {
            log.notice("Routing Finder app-url action '\(appUrl.action.rawValue)' for \(appUrl.files.count) file(s)")
            var handler: AppUrlHandler?

            // we will be here if this is a valid app url
            // (url starting with app.ziptoolpro:// scheme)
            switch appUrl.action {
            case .open:
                handler = AppUrlOpenHandler()
            case .extractFiles:
//                handler = AppUrlExtractFilesHandler()
                break
            case .extractHere:
                handler = AppUrlExtractHereHandler(catalog: appState.catalog, engineSelector: appState.engineSelector)
            case .extractToFolder:
                handler = AppUrlExtractToFolderHandler(catalog: appState.catalog, engineSelector: appState.engineSelector)
            }

            guard let handler else {
                log.error("No handler available for action '\(appUrl.action.rawValue)'")
                return
            }
            guard let archiveWindowManager else {
                log.error("Archive window manager not ready; dropping action '\(appUrl.action.rawValue)'")
                return
            }

            // we have all the url info, start the handlers now
            handler.handle(appUrl: appUrl, archiveWindowManager: archiveWindowManager)

            // no need to move further here as it was an app url
            return
        }

        // it is not an app url, therefore the assumption is that the app
        // was opened via Finder > right click > Open with...
        for url in urls {
            log.notice("Open-with: opening \(url.lastPathComponent)")
            archiveWindowManager?.openArchiveWindow(for: url)
        }
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        guard !Self.isRunningInPreview else { return }
        log.notice("applicationDidFinishLaunching — creating window manager")

        archiveWindowManager = ArchiveWindowManager(appState: appState)
        observeMenuRebuildTriggers()
        scheduleApplicationMenuConfiguration()

        // make sure that at least one window will be shown
        // even if it is empty
        log.notice("Opening launch window (pending open urls: \(pendingOpenURLs.count))")
        archiveWindowManager?.openLaunchArchiveWindow()

        // replay any open urls that arrived before the window manager existed
        if !pendingOpenURLs.isEmpty {
            let queued = pendingOpenURLs
            pendingOpenURLs.removeAll()
            log.notice("Replaying \(queued.count) queued open url(s)")
            application(NSApp, open: queued)
        }

        log.notice("applicationDidFinishLaunching done")
    }

    public func applicationDidBecomeActive(_ notification: Notification) {
        configureApplicationMenus()
    }

    public func applicationDidUpdate(_ notification: Notification) {
        configureApplicationMenus()
    }

    public func menuNeedsUpdate(_ menu: NSMenu) {
        if menu === managedWindowMenu {
            rebuildWindowMenu(menu)
        }
    }
    
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        guard !Self.isRunningInPreview else { return true }
        log.debug("applicationShouldHandleReopen (hasVisibleWindows: \(hasVisibleWindows))")
        if !hasVisibleWindows {
            archiveWindowManager?.openArchiveWindow()
            NSApp.activate(ignoringOtherApps: true)
        }
        return true
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        if quitOnLastWindowClosed {
            return true
        }
        return false
    }

    public func applicationWillTerminate(_ notification: Notification) {
        guard !Self.isRunningInPreview else { return }
        log.notice("applicationWillTerminate — cleaning cache")
        CacheCleaner().clean()
    }

    @objc private func showMainWindowFromMenu(_ sender: Any?) {
        log.debug("showMainWindowFromMenu")
        archiveWindowManager?.openArchiveWindow()
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func newWindowFromMenu(_ sender: Any?) {
        log.debug("newWindowFromMenu")
        archiveWindowManager?.openNewArchiveWindow()
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func minimizeWindowFromMenu(_ sender: Any?) {
        log.debug("minimizeWindowFromMenu")
        (NSApp.keyWindow ?? NSApp.mainWindow)?.performMiniaturize(sender)
    }

    private func scheduleApplicationMenuConfiguration() {
        configureApplicationMenus()

        for delay in [0.05, 0.2, 0.6] {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.configureApplicationMenus()
            }
        }
    }

    private func observeMenuRebuildTriggers() {
        let notificationCenter = NotificationCenter.default
        for name in [NSWindow.didMiniaturizeNotification, NSWindow.didDeminiaturizeNotification] {
            notificationCenter.addObserver(
                self,
                selector: #selector(applicationMenuNeedsConfiguration(_:)),
                name: name,
                object: nil
            )
        }
    }

    @objc private func applicationMenuNeedsConfiguration(_ notification: Notification) {
        configureApplicationMenus()
        DispatchQueue.main.async { [weak self] in
            self?.configureApplicationMenus()
        }
    }

    private func configureApplicationMenus() {
        removeDefaultApplicationMenus()
        configureWindowMenu()
        removeDefaultApplicationMenus()
    }

    private func removeDefaultApplicationMenus() {
        guard let mainMenu = NSApp.mainMenu else { return }

        for item in mainMenu.items.reversed() where shouldRemoveMenuItem(item) {
            mainMenu.removeItem(item)
        }
    }

    private func shouldRemoveMenuItem(_ item: NSMenuItem) -> Bool {
        if item.submenu === managedWindowMenu {
            return false
        }

        let title = item.title
        if title == AppLocalization.localizedString("Window") || title == "Window" || title == "窗口" {
            return false
        }

        if title == Bundle.main.localizedDisplayName || title == Bundle.main.displayName || title == Bundle.main.appName {
            return false
        }

        return true
    }

    private func configureWindowMenu() {
        guard let mainMenu = NSApp.mainMenu else { return }

        let windowMenuItem = mainMenu.items.first { $0.title == "Window" || $0.title == "窗口" } ?? {
            let item = NSMenuItem(title: AppLocalization.localizedString("Window"), action: nil, keyEquivalent: "")
            let submenu = NSMenu(title: item.title)
            item.submenu = submenu
            mainMenu.addItem(item)
            return item
        }()
        windowMenuItem.title = AppLocalization.localizedString("Window")

        let windowMenu = windowMenuItem.submenu ?? NSMenu(title: windowMenuItem.title)
        windowMenu.title = windowMenuItem.title
        windowMenuItem.submenu = windowMenu
        windowMenu.delegate = self
        managedWindowMenu = windowMenu
        NSApp.windowsMenu = nil
        rebuildWindowMenu(windowMenu)
    }

    private func rebuildWindowMenu(_ windowMenu: NSMenu) {
        windowMenu.removeAllItems()

        let newWindowItem = NSMenuItem(
            title: AppLocalization.localizedString("New Window"),
            action: #selector(newWindowFromMenu(_:)),
            keyEquivalent: "n"
        )
        newWindowItem.keyEquivalentModifierMask = [.command]
        newWindowItem.target = self
        newWindowItem.tag = newWindowMenuItemTag
        windowMenu.addItem(newWindowItem)

        let showMainWindowItem = NSMenuItem(
            title: AppLocalization.localizedString("Show Main Window"),
            action: #selector(showMainWindowFromMenu(_:)),
            keyEquivalent: "0"
        )
        showMainWindowItem.keyEquivalentModifierMask = [.command]
        showMainWindowItem.target = self
        showMainWindowItem.tag = showMainWindowMenuItemTag
        windowMenu.addItem(showMainWindowItem)

        let minimizeItem = NSMenuItem(
            title: AppLocalization.localizedString("Minimize"),
            action: #selector(minimizeWindowFromMenu(_:)),
            keyEquivalent: "m"
        )
        minimizeItem.keyEquivalentModifierMask = [.command]
        minimizeItem.target = self
        windowMenu.addItem(minimizeItem)
    }
}
