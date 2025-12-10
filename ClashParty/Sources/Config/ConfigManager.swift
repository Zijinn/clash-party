//
//  ConfigManager.swift
//  ClashParty
//
//  Configuration management system
//

import Foundation
import Combine

struct AppConfig: Codable {
    var httpPort: Int = 7890
    var socksPort: Int = 7891
    var mixedPort: Int = 7892
    var allowLAN: Bool = false
    var logLevel: String = "info"
    var externalController: String = "127.0.0.1:9090"
    var secret: String = ""
    var mode: String = "rule"
    var ipv6: Bool = false
    var tun: TunConfig?
}

struct TunConfig: Codable {
    var enable: Bool = false
    var stack: String = "system"
    var dnsHijack: [String] = ["any:53"]
    var autoRoute: Bool = true
    var autoDetectInterface: Bool = true
}

@MainActor
class ConfigManager: ObservableObject {
    static let shared = ConfigManager()
    
    @Published var profiles: [Profile] = []
    @Published var appConfig: AppConfig = AppConfig()
    
    private let configDirectory: URL
    private let configFile: URL
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        configDirectory = appSupport.appendingPathComponent("ClashParty")
        configFile = configDirectory.appendingPathComponent("config.yaml")
        
        // Create directory if needed
        try? FileManager.default.createDirectory(at: configDirectory, withIntermediateDirectories: true)
        
        Logger.shared.info("ConfigManager initialized")
        loadConfig()
        loadProfiles()
    }
    
    func loadConfig() {
        Logger.shared.info("Loading configuration")
        
        // Load app config from UserDefaults or file
        if let data = UserDefaults.standard.data(forKey: "appConfig"),
           let config = try? JSONDecoder().decode(AppConfig.self, from: data) {
            appConfig = config
        }
    }
    
    func saveConfig() {
        Logger.shared.info("Saving configuration")
        
        if let data = try? JSONEncoder().encode(appConfig) {
            UserDefaults.standard.set(data, forKey: "appConfig")
        }
    }
    
    func loadProfiles() {
        Logger.shared.info("Loading profiles")
        
        let profilesFile = configDirectory.appendingPathComponent("profiles.json")
        
        if let data = try? Data(contentsOf: profilesFile),
           let loadedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
            profiles = loadedProfiles
        } else {
            // Create default profile
            profiles = [
                Profile(
                    id: UUID(),
                    name: "Default",
                    url: nil,
                    isActive: true,
                    updatedAt: Date()
                )
            ]
        }
    }
    
    func saveProfiles() {
        Logger.shared.info("Saving profiles")
        
        let profilesFile = configDirectory.appendingPathComponent("profiles.json")
        
        if let data = try? JSONEncoder().encode(profiles) {
            try? data.write(to: profilesFile)
        }
    }
    
    func addProfile(_ profile: Profile) {
        profiles.append(profile)
        saveProfiles()
    }
    
    func removeProfile(_ profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfiles()
    }
    
    func setActiveProfile(_ profile: Profile) {
        for i in 0..<profiles.count {
            profiles[i].isActive = profiles[i].id == profile.id
        }
        saveProfiles()
    }
    
    func updateProfile(from url: String) async throws {
        Logger.shared.info("Updating profile from: \(url)")
        
        guard let profileURL = URL(string: url) else {
            throw NSError(domain: "ConfigManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: profileURL)
        
        // Save downloaded config
        try data.write(to: configFile)
        
        Logger.shared.info("Profile updated successfully")
    }
    
    func exportConfig() throws -> URL {
        guard FileManager.default.fileExists(atPath: configFile.path) else {
            throw NSError(domain: "ConfigManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Config file not found"])
        }
        
        return configFile
    }
    
    func importConfig(from url: URL) throws {
        let data = try Data(contentsOf: url)
        try data.write(to: configFile)
        loadConfig()
        Logger.shared.info("Config imported successfully")
    }
}
