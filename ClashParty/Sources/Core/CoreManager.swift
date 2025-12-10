//
//  CoreManager.swift
//  ClashParty
//
//  Core proxy manager for Mihomo integration
//

import Foundation
import Combine

struct ProxyInfo: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let delay: Int?
}

@MainActor
class CoreManager: ObservableObject {
    static let shared = CoreManager()
    
    @Published var isRunning = false
    @Published var uploadSpeed: Int64 = 0
    @Published var downloadSpeed: Int64 = 0
    @Published var proxies: [ProxyInfo] = []
    
    private var coreProcess: Process?
    private var trafficTimer: Timer?
    
    private init() {
        Logger.shared.info("CoreManager initialized")
    }
    
    func initialize() async {
        Logger.shared.info("Initializing core manager")
        // Load configuration
        // Initialize mihomo core
    }
    
    func start() async {
        guard !isRunning else {
            Logger.shared.warning("Core is already running")
            return
        }
        
        Logger.shared.info("Starting mihomo core")
        
        // Get core binary path
        guard let corePath = getCoreExecutablePath() else {
            Logger.shared.error("Core executable not found")
            return
        }
        
        // Start mihomo process
        coreProcess = Process()
        coreProcess?.executableURL = URL(fileURLWithPath: corePath)
        coreProcess?.arguments = ["-d", getConfigDirectory()]
        
        do {
            try coreProcess?.run()
            isRunning = true
            startTrafficMonitoring()
            Logger.shared.info("Core started successfully")
        } catch {
            Logger.shared.error("Failed to start core: \(error.localizedDescription)")
        }
    }
    
    func stop() async {
        guard isRunning else {
            Logger.shared.warning("Core is not running")
            return
        }
        
        Logger.shared.info("Stopping mihomo core")
        
        coreProcess?.terminate()
        coreProcess = nil
        isRunning = false
        stopTrafficMonitoring()
        
        Logger.shared.info("Core stopped")
    }
    
    func shutdown() async {
        await stop()
    }
    
    func restart() async {
        await stop()
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        await start()
    }
    
    private func getCoreExecutablePath() -> String? {
        // Look for mihomo binary in application bundle
        if let bundlePath = Bundle.main.resourcePath {
            let corePath = bundlePath + "/mihomo"
            if FileManager.default.fileExists(atPath: corePath) {
                return corePath
            }
        }
        
        // Fallback to system path
        let possiblePaths = [
            "/usr/local/bin/mihomo",
            "/opt/homebrew/bin/mihomo",
            FileManager.default.homeDirectoryForCurrentUser.path + "/mihomo"
        ]
        
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        return nil
    }
    
    private func getConfigDirectory() -> String {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let configDir = appSupport.appendingPathComponent("ClashParty")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)
        
        return configDir.path
    }
    
    private func startTrafficMonitoring() {
        trafficTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.updateTrafficStats()
            }
        }
    }
    
    private func stopTrafficMonitoring() {
        trafficTimer?.invalidate()
        trafficTimer = nil
        uploadSpeed = 0
        downloadSpeed = 0
    }
    
    private func updateTrafficStats() async {
        // Query mihomo API for traffic statistics
        // This would typically connect to http://127.0.0.1:9090/traffic
        guard let url = URL(string: "http://127.0.0.1:9090/traffic") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let up = json["up"] as? Int64 {
                    uploadSpeed = up
                }
                if let down = json["down"] as? Int64 {
                    downloadSpeed = down
                }
            }
        } catch {
            // Ignore errors in traffic monitoring
        }
    }
    
    func loadProxies() async {
        guard let url = URL(string: "http://127.0.0.1:9090/proxies") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let proxiesDict = json["proxies"] as? [String: [String: Any]] {
                
                var newProxies: [ProxyInfo] = []
                for (name, info) in proxiesDict {
                    if let type = info["type"] as? String {
                        let delay = info["delay"] as? Int
                        newProxies.append(ProxyInfo(name: name, type: type, delay: delay))
                    }
                }
                
                await MainActor.run {
                    self.proxies = newProxies
                }
            }
        } catch {
            Logger.shared.error("Failed to load proxies: \(error.localizedDescription)")
        }
    }
}
