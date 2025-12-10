//
//  ConnectionsDetailView.swift
//  ClashParty
//
//  Detailed view of active connections
//

import SwiftUI

struct ConnectionsDetailView: View {
    @StateObject private var connectionsManager = ConnectionsManager.shared
    @State private var searchText = ""
    @State private var selectedConnection: Connection?
    
    var filteredConnections: [Connection] {
        if searchText.isEmpty {
            return connectionsManager.connections
        }
        return connectionsManager.connections.filter { connection in
            connection.metadata.host.localizedCaseInsensitiveContains(searchText) ||
            connection.metadata.destinationIP.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            // Header with statistics
            HStack(spacing: 40) {
                VStack {
                    Text("Active Connections")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(connectionsManager.activeConnectionCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack {
                    Text("Total Upload")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatBytes(connectionsManager.totalUpload))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack {
                    Text("Total Download")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatBytes(connectionsManager.totalDownload))
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            
            Divider()
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search connections...", text: $searchText)
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
            .padding(.horizontal)
            
            // Connections list
            List(filteredConnections) { connection in
                ConnectionRow(connection: connection)
                    .contextMenu {
                        Button("Close Connection") {
                            Task {
                                await connectionsManager.closeConnection(connection.id)
                            }
                        }
                        Button("Copy Host") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(connection.metadata.host, forType: .string)
                        }
                    }
            }
            
            // Footer
            HStack {
                Button("Close All") {
                    Task {
                        await connectionsManager.closeAllConnections()
                    }
                }
                .disabled(connectionsManager.connections.isEmpty)
                
                Spacer()
                
                Button("Refresh") {
                    Task {
                        await connectionsManager.fetchConnections()
                    }
                }
            }
            .padding()
        }
        .onAppear {
            connectionsManager.startMonitoring()
        }
        .onDisappear {
            connectionsManager.stopMonitoring()
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

struct ConnectionRow: View {
    let connection: Connection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: networkIcon)
                    .foregroundColor(.blue)
                Text(connection.metadata.host)
                    .font(.headline)
                Spacer()
                Text(connection.chains.joined(separator: " → "))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(connection.metadata.sourceIP):\(connection.metadata.sourcePort)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(connection.metadata.destinationIP):\(connection.metadata.destinationPort)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                HStack(spacing: 12) {
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.up")
                            .font(.caption2)
                        Text(formatBytes(connection.upload))
                            .font(.caption)
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.down")
                            .font(.caption2)
                        Text(formatBytes(connection.download))
                            .font(.caption)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            if let processPath = connection.metadata.processPath {
                Text("Process: \(processPath)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var networkIcon: String {
        switch connection.metadata.network {
        case "tcp":
            return "arrow.left.arrow.right"
        case "udp":
            return "arrow.up.arrow.down"
        default:
            return "network"
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

#Preview {
    ConnectionsDetailView()
}
