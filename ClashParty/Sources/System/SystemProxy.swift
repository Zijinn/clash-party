//
//  SystemProxy.swift
//  ClashParty
//
//  System proxy configuration for macOS
//

import Foundation
import SystemConfiguration

class SystemProxy {
    static let shared = SystemProxy()
    
    private init() {}
    
    func setSystemProxy(httpPort: Int, socksPort: Int) throws {
        Logger.shared.info("Setting system proxy - HTTP: \(httpPort), SOCKS: \(socksPort)")
        
        guard let prefRef = SCPreferencesCreate(nil, "ClashParty" as CFString, nil) else {
            throw NSError(domain: "SystemProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create preferences"])
        }
        
        guard let sets = SCPreferencesGetValue(prefRef, kSCPrefNetworkServices) as? [String: Any] else {
            throw NSError(domain: "SystemProxy", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get network services"])
        }
        
        for (key, value) in sets {
            guard let service = value as? [String: Any],
                  let hardware = service["Interface"] as? [String: Any],
                  let type = hardware["Type"] as? String else {
                continue
            }
            
            // Only configure ethernet and Wi-Fi
            if type != "Ethernet" && type != "IEEE80211" {
                continue
            }
            
            let servicePath = "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString
            guard let proxies = SCPreferencesPathGetValue(prefRef, servicePath) as? [String: Any] else {
                continue
            }
            
            var newProxies = proxies
            
            // Set HTTP proxy
            newProxies[kSCPropNetProxiesHTTPEnable as String] = 1
            newProxies[kSCPropNetProxiesHTTPProxy as String] = "127.0.0.1"
            newProxies[kSCPropNetProxiesHTTPPort as String] = httpPort
            
            // Set HTTPS proxy
            newProxies[kSCPropNetProxiesHTTPSEnable as String] = 1
            newProxies[kSCPropNetProxiesHTTPSProxy as String] = "127.0.0.1"
            newProxies[kSCPropNetProxiesHTTPSPort as String] = httpPort
            
            // Set SOCKS proxy
            newProxies[kSCPropNetProxiesSOCKSEnable as String] = 1
            newProxies[kSCPropNetProxiesSOCKSProxy as String] = "127.0.0.1"
            newProxies[kSCPropNetProxiesSOCKSPort as String] = socksPort
            
            SCPreferencesPathSetValue(prefRef, servicePath, newProxies as CFDictionary)
        }
        
        guard SCPreferencesCommitChanges(prefRef) else {
            throw NSError(domain: "SystemProxy", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to commit changes"])
        }
        
        guard SCPreferencesApplyChanges(prefRef) else {
            throw NSError(domain: "SystemProxy", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to apply changes"])
        }
        
        Logger.shared.info("System proxy set successfully")
    }
    
    func clearSystemProxy() throws {
        Logger.shared.info("Clearing system proxy")
        
        guard let prefRef = SCPreferencesCreate(nil, "ClashParty" as CFString, nil) else {
            throw NSError(domain: "SystemProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create preferences"])
        }
        
        guard let sets = SCPreferencesGetValue(prefRef, kSCPrefNetworkServices) as? [String: Any] else {
            throw NSError(domain: "SystemProxy", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get network services"])
        }
        
        for (key, value) in sets {
            guard let service = value as? [String: Any],
                  let hardware = service["Interface"] as? [String: Any],
                  let type = hardware["Type"] as? String else {
                continue
            }
            
            if type != "Ethernet" && type != "IEEE80211" {
                continue
            }
            
            let servicePath = "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString
            guard let proxies = SCPreferencesPathGetValue(prefRef, servicePath) as? [String: Any] else {
                continue
            }
            
            var newProxies = proxies
            
            // Disable HTTP proxy
            newProxies[kSCPropNetProxiesHTTPEnable as String] = 0
            newProxies[kSCPropNetProxiesHTTPSEnable as String] = 0
            newProxies[kSCPropNetProxiesSOCKSEnable as String] = 0
            
            SCPreferencesPathSetValue(prefRef, servicePath, newProxies as CFDictionary)
        }
        
        guard SCPreferencesCommitChanges(prefRef) else {
            throw NSError(domain: "SystemProxy", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to commit changes"])
        }
        
        guard SCPreferencesApplyChanges(prefRef) else {
            throw NSError(domain: "SystemProxy", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to apply changes"])
        }
        
        Logger.shared.info("System proxy cleared successfully")
    }
    
    func getSystemProxyStatus() -> (httpEnabled: Bool, socksEnabled: Bool) {
        guard let prefRef = SCPreferencesCreate(nil, "ClashParty" as CFString, nil),
              let sets = SCPreferencesGetValue(prefRef, kSCPrefNetworkServices) as? [String: Any] else {
            return (false, false)
        }
        
        for (key, value) in sets {
            guard let service = value as? [String: Any],
                  let hardware = service["Interface"] as? [String: Any],
                  let type = hardware["Type"] as? String,
                  (type == "Ethernet" || type == "IEEE80211") else {
                continue
            }
            
            let servicePath = "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString
            if let proxies = SCPreferencesPathGetValue(prefRef, servicePath) as? [String: Any] {
                let httpEnabled = (proxies[kSCPropNetProxiesHTTPEnable as String] as? Int) == 1
                let socksEnabled = (proxies[kSCPropNetProxiesSOCKSEnable as String] as? Int) == 1
                return (httpEnabled, socksEnabled)
            }
        }
        
        return (false, false)
    }
}
