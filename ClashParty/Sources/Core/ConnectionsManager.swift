//
//  ConnectionsManager.swift
//  ClashParty
//
//  Manages active proxy connections
//

import Foundation

struct Connection: Identifiable, Codable {
    let id: String
    let chains: [String]
    let rule: String
    let start: String
    let upload: Int64
    let download: Int64
    let metadata: ConnectionMetadata
}

struct ConnectionMetadata: Codable {
    let network: String
    let type: String
    let sourceIP: String
    let destinationIP: String
    let sourcePort: String
    let destinationPort: String
    let host: String
    let dnsMode: String?
    let processPath: String?
    
    enum CodingKeys: String, CodingKey {
        case network
        case type
        case sourceIP
        case destinationIP
        case sourcePort
        case destinationPort
        case host
        case dnsMode
        case processPath
    }
}

@MainActor
class ConnectionsManager: ObservableObject {
    static let shared = ConnectionsManager()
    
    @Published var connections: [Connection] = []
    @Published var activeConnectionCount: Int = 0
    @Published var totalUpload: Int64 = 0
    @Published var totalDownload: Int64 = 0
    
    private var updateTimer: Timer?
    
    private init() {}
    
    func startMonitoring() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.fetchConnections()
            }
        }
    }
    
    func stopMonitoring() {
        updateTimer?.invalidate()
        updateTimer = nil
        connections = []
        activeConnectionCount = 0
    }
    
    func fetchConnections() async {
        guard let url = URL(string: "http://127.0.0.1:9090/connections") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let connectionsData = json["connections"] as? [[String: Any]] {
                
                var newConnections: [Connection] = []
                var upload: Int64 = 0
                var download: Int64 = 0
                
                for connData in connectionsData {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: connData),
                       let connection = try? JSONDecoder().decode(Connection.self, from: jsonData) {
                        newConnections.append(connection)
                        upload += connection.upload
                        download += connection.download
                    }
                }
                
                await MainActor.run {
                    self.connections = newConnections
                    self.activeConnectionCount = newConnections.count
                    self.totalUpload = upload
                    self.totalDownload = download
                }
            }
        } catch {
            // Ignore errors in connection monitoring
        }
    }
    
    func closeConnection(_ connectionId: String) async {
        guard let url = URL(string: "http://127.0.0.1:9090/connections/\(connectionId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            _ = try await URLSession.shared.data(for: request)
            Logger.shared.info("Closed connection: \(connectionId)")
            await fetchConnections()
        } catch {
            Logger.shared.error("Failed to close connection: \(error.localizedDescription)")
        }
    }
    
    func closeAllConnections() async {
        for connection in connections {
            await closeConnection(connection.id)
        }
    }
}
