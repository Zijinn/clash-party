//
//  ContentView.swift
//  ClashParty
//
//  Created by Clash Party Team
//  Copyright © 2024 Mihomo Party. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coreManager: CoreManager
    @EnvironmentObject var configManager: ConfigManager
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Label("Overview", systemImage: "chart.bar.fill")
                    .tag(0)
                Label("Proxies", systemImage: "network")
                    .tag(1)
                Label("Profiles", systemImage: "doc.text.fill")
                    .tag(2)
                Label("Rules", systemImage: "list.bullet")
                    .tag(3)
                Label("Connections", systemImage: "link")
                    .tag(4)
                Label("Logs", systemImage: "text.justify")
                    .tag(5)
            }
            .navigationTitle("Clash Party")
            .frame(minWidth: 200)
        } detail: {
            switch selectedTab {
            case 0:
                OverviewView()
            case 1:
                ProxiesView()
            case 2:
                ProfilesView()
            case 3:
                RulesView()
            case 4:
                ConnectionsView()
            case 5:
                LogsView()
            default:
                Text("Select a tab")
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

// MARK: - Overview View
struct OverviewView: View {
    @EnvironmentObject var coreManager: CoreManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Clash Party")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                VStack {
                    Text("Status")
                        .font(.headline)
                    Text(coreManager.isRunning ? "Running" : "Stopped")
                        .foregroundColor(coreManager.isRunning ? .green : .red)
                        .font(.title2)
                }
                
                VStack {
                    Text("Upload")
                        .font(.headline)
                    Text(formatBytes(coreManager.uploadSpeed))
                        .font(.title2)
                }
                
                VStack {
                    Text("Download")
                        .font(.headline)
                    Text(formatBytes(coreManager.downloadSpeed))
                        .font(.title2)
                }
            }
            .padding()
            
            Button(action: {
                Task {
                    if coreManager.isRunning {
                        await coreManager.stop()
                    } else {
                        await coreManager.start()
                    }
                }
            }) {
                Text(coreManager.isRunning ? "Stop" : "Start")
                    .frame(width: 120)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
        }
        .padding()
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes) + "/s"
    }
}

// MARK: - Proxies View
struct ProxiesView: View {
    @EnvironmentObject var coreManager: CoreManager
    
    var body: some View {
        List {
            ForEach(coreManager.proxies, id: \.name) { proxy in
                HStack {
                    Image(systemName: "network")
                    Text(proxy.name)
                    Spacer()
                    Text(proxy.type)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Proxies")
    }
}

// MARK: - Profiles View
struct ProfilesView: View {
    @EnvironmentObject var configManager: ConfigManager
    @State private var showingAddProfile = false
    
    var body: some View {
        VStack {
            List {
                ForEach(configManager.profiles, id: \.id) { profile in
                    ProfileRow(profile: profile)
                }
            }
            
            HStack {
                Button("Add Profile") {
                    showingAddProfile = true
                }
                Button("Refresh All") {
                    Task {
                        await configManager.loadProfiles()
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profiles")
        .sheet(isPresented: $showingAddProfile) {
            AddProfileView()
        }
    }
}

struct ProfileRow: View {
    let profile: Profile
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text")
            VStack(alignment: .leading) {
                Text(profile.name)
                    .font(.headline)
                if let url = profile.url {
                    Text(url)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if profile.isActive {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var url = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Profile")
                .font(.title2)
                .fontWeight(.bold)
            
            TextField("Profile Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Subscription URL (optional)", text: $url)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Add") {
                    let newProfile = Profile(
                        name: name,
                        url: url.isEmpty ? nil : url,
                        isActive: false
                    )
                    ConfigManager.shared.addProfile(newProfile)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
    }
}

// MARK: - Rules View
struct RulesView: View {
    var body: some View {
        Text("Rules")
            .font(.largeTitle)
            .navigationTitle("Rules")
    }
}

// MARK: - Connections View
struct ConnectionsView: View {
    var body: some View {
        Text("Active Connections")
            .font(.largeTitle)
            .navigationTitle("Connections")
    }
}

// MARK: - Logs View
struct LogsView: View {
    @State private var logs: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(logs, id: \.self) { log in
                    Text(log)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                }
            }
            .padding()
        }
        .navigationTitle("Logs")
        .onAppear {
            // Load logs
            logs = Logger.shared.getRecentLogs()
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var configManager: ConfigManager
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            ProxySettingsView()
                .tabItem {
                    Label("Proxy", systemImage: "network")
                }
            
            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced", systemImage: "wrench.and.screwdriver")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("startAtLogin") private var startAtLogin = false
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        Form {
            Toggle("Start at Login", isOn: $startAtLogin)
            Toggle("Dark Mode", isOn: $darkMode)
        }
        .padding()
    }
}

struct ProxySettingsView: View {
    @AppStorage("systemProxy") private var systemProxy = false
    @AppStorage("httpPort") private var httpPort = 7890
    @AppStorage("socksPort") private var socksPort = 7891
    
    var body: some View {
        Form {
            Toggle("Set as System Proxy", isOn: $systemProxy)
            TextField("HTTP Port", value: $httpPort, format: .number)
            TextField("SOCKS Port", value: $socksPort, format: .number)
        }
        .padding()
    }
}

struct AdvancedSettingsView: View {
    @AppStorage("allowLAN") private var allowLAN = false
    @AppStorage("logLevel") private var logLevel = "info"
    
    var body: some View {
        Form {
            Toggle("Allow LAN", isOn: $allowLAN)
            Picker("Log Level", selection: $logLevel) {
                Text("Silent").tag("silent")
                Text("Error").tag("error")
                Text("Warning").tag("warning")
                Text("Info").tag("info")
                Text("Debug").tag("debug")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(CoreManager.shared)
        .environmentObject(ConfigManager.shared)
}
