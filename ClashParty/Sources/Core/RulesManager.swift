//
//  RulesManager.swift
//  ClashParty
//
//  Manages proxy rules
//

import Foundation

struct ProxyRule: Identifiable {
    let id = UUID()
    let type: String
    let payload: String
    let proxy: String
}

@MainActor
class RulesManager: ObservableObject {
    static let shared = RulesManager()
    
    @Published var rules: [ProxyRule] = []
    @Published var mode: String = "rule"
    
    private init() {}
    
    func loadRules() async {
        guard let url = URL(string: "http://127.0.0.1:9090/rules") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let rulesData = json["rules"] as? [[String: Any]] {
                
                var newRules: [ProxyRule] = []
                for ruleData in rulesData {
                    if let type = ruleData["type"] as? String,
                       let payload = ruleData["payload"] as? String,
                       let proxy = ruleData["proxy"] as? String {
                        newRules.append(ProxyRule(type: type, payload: payload, proxy: proxy))
                    }
                }
                
                await MainActor.run {
                    self.rules = newRules
                }
            }
        } catch {
            Logger.shared.error("Failed to load rules: \(error.localizedDescription)")
        }
    }
    
    func setMode(_ newMode: String) async {
        guard let url = URL(string: "http://127.0.0.1:9090/configs") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["mode": newMode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            _ = try await URLSession.shared.data(for: request)
            await MainActor.run {
                self.mode = newMode
            }
            Logger.shared.info("Set mode to: \(newMode)")
        } catch {
            Logger.shared.error("Failed to set mode: \(error.localizedDescription)")
        }
    }
    
    func getMode() async {
        guard let url = URL(string: "http://127.0.0.1:9090/configs") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let mode = json["mode"] as? String {
                await MainActor.run {
                    self.mode = mode
                }
            }
        } catch {
            Logger.shared.error("Failed to get mode: \(error.localizedDescription)")
        }
    }
}
