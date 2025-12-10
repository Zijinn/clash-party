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
            VStack(spacing: 0) {
                // App header in sidebar
                VStack(spacing: 8) {
                    Image(systemName: "network.badge.shield.half.filled")
                        .font(.system(size: 36))
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Clash Party")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    // Status indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(coreManager.isRunning ? Color.green : Color.gray)
                            .frame(width: 6, height: 6)
                        
                        Text(coreManager.isRunning ? "Running" : "Stopped")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 20)
                
                Divider()
                
                // Navigation list
                List(selection: $selectedTab) {
                    Section("Main") {
                        SidebarItem(title: "Overview", icon: "gauge.with.dots.needle.67percent", tag: 0, selectedTab: $selectedTab)
                        SidebarItem(title: "Proxies", icon: "network", tag: 1, selectedTab: $selectedTab)
                        SidebarItem(title: "Profiles", icon: "doc.text.fill", tag: 2, selectedTab: $selectedTab)
                    }
                    
                    Section("Monitoring") {
                        SidebarItem(title: "Rules", icon: "list.bullet.rectangle", tag: 3, selectedTab: $selectedTab)
                        SidebarItem(title: "Connections", icon: "link.circle.fill", tag: 4, selectedTab: $selectedTab)
                        SidebarItem(title: "Logs", icon: "terminal.fill", tag: 5, selectedTab: $selectedTab)
                    }
                }
                .listStyle(.sidebar)
            }
            .navigationTitle("")
            .frame(minWidth: 220)
        } detail: {
            Group {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 900, minHeight: 650)
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

// MARK: - Sidebar Item
struct SidebarItem: View {
    let title: String
    let icon: String
    let tag: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Label(title, systemImage: icon)
            .tag(tag)
            .badge(getBadge())
    }
    
    private func getBadge() -> Int? {
        // Could show counts for connections, new logs, etc.
        return nil
    }
}

// MARK: - Overview View
struct OverviewView: View {
    @EnvironmentObject var coreManager: CoreManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with app icon and title
                VStack(spacing: 12) {
                    Image(systemName: "network.badge.shield.half.filled")
                        .font(.system(size: 64))
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 10)
                    
                    Text("Clash Party")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    
                    Text("Mihomo Proxy Management")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Status card
                GroupBox {
                    HStack(spacing: 0) {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(coreManager.isRunning ? Color.green : Color.red)
                                    .frame(width: 12, height: 12)
                                    .shadow(color: coreManager.isRunning ? .green.opacity(0.5) : .red.opacity(0.5), radius: 4)
                                
                                Text(coreManager.isRunning ? "Running" : "Stopped")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                            Button(action: {
                                Task {
                                    if coreManager.isRunning {
                                        await coreManager.stop()
                                    } else {
                                        await coreManager.start()
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: coreManager.isRunning ? "stop.circle.fill" : "play.circle.fill")
                                    Text(coreManager.isRunning ? "Stop Proxy" : "Start Proxy")
                                }
                                .frame(width: 160)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(coreManager.isRunning ? .red : .green)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                } label: {
                    Label("Proxy Status", systemImage: "power.circle")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                // Traffic statistics
                GroupBox {
                    HStack(spacing: 30) {
                        TrafficStatCard(
                            title: "Upload",
                            value: formatBytes(coreManager.uploadSpeed),
                            icon: "arrow.up.circle.fill",
                            color: .orange
                        )
                        
                        Divider()
                            .frame(height: 60)
                        
                        TrafficStatCard(
                            title: "Download",
                            value: formatBytes(coreManager.downloadSpeed),
                            icon: "arrow.down.circle.fill",
                            color: .blue
                        )
                    }
                    .padding()
                } label: {
                    Label("Network Traffic", systemImage: "chart.line.uptrend.xyaxis")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                // Quick actions
                GroupBox {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            QuickActionButton(
                                title: "Proxies",
                                icon: "network",
                                color: .blue
                            )
                            
                            QuickActionButton(
                                title: "Profiles",
                                icon: "doc.text.fill",
                                color: .green
                            )
                        }
                        
                        HStack(spacing: 16) {
                            QuickActionButton(
                                title: "Rules",
                                icon: "list.bullet.rectangle",
                                color: .orange
                            )
                            
                            QuickActionButton(
                                title: "Connections",
                                icon: "link.circle.fill",
                                color: .purple
                            )
                        }
                    }
                    .padding()
                } label: {
                    Label("Quick Actions", systemImage: "bolt.fill")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom)
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes) + "/s"
    }
}

// MARK: - Traffic Stat Card
struct TrafficStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Proxies View
struct ProxiesView: View {
    @EnvironmentObject var coreManager: CoreManager
    @State private var searchText = ""
    @State private var selectedProxyType = "All"
    
    let proxyTypes = ["All", "Shadowsocks", "VMess", "Trojan", "SOCKS5", "HTTP"]
    
    var filteredProxies: [Proxy] {
        var proxies = coreManager.proxies
        
        if selectedProxyType != "All" {
            proxies = proxies.filter { $0.type.localizedCaseInsensitiveContains(selectedProxyType) }
        }
        
        if !searchText.isEmpty {
            proxies = proxies.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return proxies
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and filter bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search proxies...", text: $searchText)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Picker("Type", selection: $selectedProxyType) {
                    ForEach(proxyTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 150)
            }
            .padding()
            
            Divider()
            
            // Proxies list
            if filteredProxies.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "network.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No proxies available")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Add profiles to see proxy nodes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filteredProxies, id: \.name) { proxy in
                        ProxyCard(proxy: proxy)
                            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Proxies (\(filteredProxies.count))")
    }
}

// MARK: - Proxy Card
struct ProxyCard: View {
    let proxy: Proxy
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: proxyIcon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(proxyColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: proxyColor.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(proxy.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(proxy.type)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(proxyColor.opacity(0.2))
                        .foregroundColor(proxyColor)
                        .cornerRadius(4)
                    
                    if let delay = proxy.delay {
                        HStack(spacing: 4) {
                            Image(systemName: "speedometer")
                                .font(.caption2)
                            Text("\(delay)ms")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Status indicator
            Circle()
                .fill(proxy.alive ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
                .shadow(color: proxy.alive ? .green.opacity(0.5) : .clear, radius: 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isHovered ? Color.gray.opacity(0.1) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .contextMenu {
            Button("Test Latency") {
                // Action placeholder
            }
            Button("Copy Name") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(proxy.name, forType: .string)
            }
        }
    }
    
    private var proxyIcon: String {
        switch proxy.type.lowercased() {
        case "shadowsocks", "ss":
            return "shield.lefthalf.filled"
        case "vmess":
            return "airplane"
        case "trojan":
            return "shield.checkered"
        case "socks5":
            return "arrow.left.arrow.right.circle"
        case "http", "https":
            return "globe"
        default:
            return "network"
        }
    }
    
    private var proxyColor: Color {
        switch proxy.type.lowercased() {
        case "shadowsocks", "ss":
            return .blue
        case "vmess":
            return .purple
        case "trojan":
            return .red
        case "socks5":
            return .orange
        case "http", "https":
            return .green
        default:
            return .gray
        }
    }
}

// MARK: - Profiles View
struct ProfilesView: View {
    @EnvironmentObject var configManager: ConfigManager
    @State private var showingAddProfile = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with actions
            HStack {
                Text("Manage your proxy profiles")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await configManager.loadProfiles()
                    }
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    showingAddProfile = true
                }) {
                    Label("Add Profile", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
            
            // Profiles grid
            if configManager.profiles.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No profiles yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Click 'Add Profile' to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                    ], spacing: 16) {
                        ForEach(configManager.profiles, id: \.id) { profile in
                            ProfileCard(profile: profile)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Profiles (\(configManager.profiles.count))")
        .sheet(isPresented: $showingAddProfile) {
            AddProfileView()
        }
    }
}

// MARK: - Profile Card
struct ProfileCard: View {
    let profile: Profile
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: profile.isActive ? "checkmark.seal.fill" : "doc.text.fill")
                    .font(.system(size: 28))
                    .foregroundColor(profile.isActive ? .green : .blue)
                
                Spacer()
                
                if profile.isActive {
                    Text("ACTIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(4)
                }
            }
            
            // Name
            Text(profile.name)
                .font(.headline)
                .lineLimit(2)
            
            // URL or description
            if let url = profile.url {
                HStack(spacing: 4) {
                    Image(systemName: "link.circle.fill")
                        .font(.caption)
                    Text(url)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundColor(.secondary)
            } else {
                Text("Local profile")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Actions
            HStack(spacing: 8) {
                Button(action: {}) {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button(action: {}) {
                    Label("Update", systemImage: "arrow.clockwise")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(profile.url == nil)
                
                Spacer()
                
                if !profile.isActive {
                    Button(action: {}) {
                        Text("Activate")
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(
                    color: isHovered ? .black.opacity(0.15) : .black.opacity(0.05),
                    radius: isHovered ? 12 : 6,
                    x: 0,
                    y: isHovered ? 6 : 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(profile.isActive ? Color.green.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .contextMenu {
            Button("Activate") {}
            Button("Edit") {}
            Button("Update") {}
            Divider()
            Button("Delete", role: .destructive) {}
        }
    }
}

struct AddProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var url = ""
    @State private var profileType = "Subscription"
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add New Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Create a new proxy configuration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            // Form
            VStack(alignment: .leading, spacing: 16) {
                // Profile type
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile Type")
                        .font(.headline)
                    
                    Picker("", selection: $profileType) {
                        Text("Subscription URL").tag("Subscription")
                        Text("Local File").tag("Local")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Profile name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile Name")
                        .font(.headline)
                    
                    TextField("Enter a descriptive name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                
                // URL (conditional)
                if profileType == "Subscription" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Subscription URL")
                            .font(.headline)
                        
                        TextField("https://example.com/subscription", text: $url)
                            .textFieldStyle(.roundedBorder)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                            Text("Enter the subscription link from your proxy provider")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Divider()
            
            // Actions
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Spacer()
                
                Button(action: {
                    let newProfile = Profile(
                        name: name,
                        url: profileType == "Subscription" ? (url.isEmpty ? nil : url) : nil,
                        isActive: false
                    )
                    ConfigManager.shared.addProfile(newProfile)
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Add Profile")
                    }
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(name.isEmpty || (profileType == "Subscription" && url.isEmpty))
            }
        }
        .padding(24)
        .frame(width: 500, height: 450)
    }
}

// MARK: - Rules View
struct RulesView: View {
    var body: some View {
        RulesDetailView()
    }
}

// MARK: - Connections View
struct ConnectionsView: View {
    var body: some View {
        ConnectionsDetailView()
    }
}

// MARK: - Logs View
struct LogsView: View {
    @State private var logs: [String] = []
    @State private var searchText = ""
    @State private var selectedLevel = "All"
    @State private var autoScroll = true
    
    let logLevels = ["All", "Debug", "Info", "Warning", "Error"]
    
    var filteredLogs: [String] {
        var filtered = logs
        
        if selectedLevel != "All" {
            filtered = filtered.filter { $0.localizedCaseInsensitiveContains(selectedLevel) }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search logs...", text: $searchText)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .frame(maxWidth: 300)
                
                // Level filter
                Picker("Level", selection: $selectedLevel) {
                    ForEach(logLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 350)
                
                Spacer()
                
                // Auto-scroll toggle
                Toggle("Auto-scroll", isOn: $autoScroll)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                
                // Clear logs
                Button(action: {
                    logs.removeAll()
                }) {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                
                // Export logs
                Button(action: {
                    exportLogs()
                }) {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            Divider()
            
            // Logs content
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(filteredLogs.enumerated()), id: \.offset) { index, log in
                            LogRow(log: log, index: index)
                                .id(index)
                        }
                    }
                }
                .onChange(of: logs.count) { _ in
                    if autoScroll && !filteredLogs.isEmpty {
                        withAnimation {
                            proxy.scrollTo(filteredLogs.count - 1, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Footer
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.caption)
                    Text("\(filteredLogs.count) log entries")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Refresh") {
                    logs = Logger.shared.getRecentLogs()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .navigationTitle("Logs")
        .onAppear {
            logs = Logger.shared.getRecentLogs()
        }
    }
    
    private func exportLogs() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "clash-party-logs.txt"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? logs.joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
}

// MARK: - Log Row
struct LogRow: View {
    let log: String
    let index: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Line number
            Text("\(index + 1)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .trailing)
            
            // Log level indicator
            Circle()
                .fill(logLevelColor)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            // Log content
            Text(log)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
        .contextMenu {
            Button("Copy") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(log, forType: .string)
            }
        }
    }
    
    private var logLevelColor: Color {
        if log.localizedCaseInsensitiveContains("error") {
            return .red
        } else if log.localizedCaseInsensitiveContains("warning") {
            return .orange
        } else if log.localizedCaseInsensitiveContains("info") {
            return .blue
        } else if log.localizedCaseInsensitiveContains("debug") {
            return .purple
        }
        return .gray
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
