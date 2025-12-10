//
//  NetworkMonitor.swift
//  ClashParty
//
//  Network connectivity monitoring
//

import Foundation
import Network

@MainActor
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    @Published var isConnected = true
    @Published var connectionType: NWInterface.InterfaceType?
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type
                
                if path.status == .satisfied {
                    Logger.shared.info("Network connection available")
                } else {
                    Logger.shared.warning("Network connection unavailable")
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    func checkConnectivity() -> Bool {
        return isConnected
    }
    
    func getConnectionDescription() -> String {
        guard isConnected else {
            return "No Connection"
        }
        
        switch connectionType {
        case .wifi:
            return "Wi-Fi"
        case .cellular:
            return "Cellular"
        case .wiredEthernet:
            return "Ethernet"
        case .loopback:
            return "Loopback"
        case .other:
            return "Other"
        default:
            return "Connected"
        }
    }
}
