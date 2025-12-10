//
//  ClashPartyApp.swift
//  ClashParty
//
//  Created by Clash Party Team
//  Copyright © 2024 Mihomo Party. All rights reserved.
//

import SwiftUI

@main
struct ClashPartyApp: App {
    @StateObject private var coreManager = CoreManager.shared
    @StateObject private var configManager = ConfigManager.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coreManager)
                .environmentObject(configManager)
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Clash Party") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.applicationName: "Clash Party",
                            NSApplication.AboutPanelOptionKey.applicationVersion: "1.8.9",
                            NSApplication.AboutPanelOptionKey.version: "1.8.9"
                        ]
                    )
                }
            }
        }
        
        Settings {
            SettingsView()
                .environmentObject(coreManager)
                .environmentObject(configManager)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Clash Party")
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
        
        // Initialize core manager
        Task {
            await CoreManager.shared.initialize()
        }
        
        Logger.shared.info("Clash Party started")
    }
    
    @objc func statusBarButtonClicked() {
        // Toggle main window or show menu
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        Task {
            await CoreManager.shared.shutdown()
        }
        Logger.shared.info("Clash Party terminated")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Keep running in menu bar
    }
}
