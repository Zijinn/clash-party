//
//  RulesDetailView.swift
//  ClashParty
//
//  Detailed view of proxy rules
//

import SwiftUI

struct RulesDetailView: View {
    @StateObject private var rulesManager = RulesManager.shared
    @State private var searchText = ""
    @State private var selectedRuleType: String = "All"
    
    let ruleTypes = ["All", "DOMAIN", "DOMAIN-SUFFIX", "DOMAIN-KEYWORD", "IP-CIDR", "GEOIP", "PROCESS-NAME", "MATCH"]
    
    var filteredRules: [ProxyRule] {
        var rules = rulesManager.rules
        
        if selectedRuleType != "All" {
            rules = rules.filter { $0.type == selectedRuleType }
        }
        
        if !searchText.isEmpty {
            rules = rules.filter { rule in
                rule.payload.localizedCaseInsensitiveContains(searchText) ||
                rule.proxy.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return rules
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Mode selector
            HStack {
                Text("Proxy Mode:")
                    .foregroundColor(.secondary)
                
                Picker("Mode", selection: Binding(
                    get: { rulesManager.mode },
                    set: { newMode in
                        Task {
                            await rulesManager.setMode(newMode)
                        }
                    }
                )) {
                    Text("Rule").tag("rule")
                    Text("Global").tag("global")
                    Text("Direct").tag("direct")
                }
                .pickerStyle(.segmented)
                .frame(width: 300)
                
                Spacer()
                
                Text("\(filteredRules.count) rules")
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Divider()
            
            // Filters
            HStack {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search rules...", text: $searchText)
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
                
                // Type filter
                Picker("Type", selection: $selectedRuleType) {
                    ForEach(ruleTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 200)
            }
            .padding()
            
            Divider()
            
            // Rules list
            if filteredRules.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No rules found")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredRules) { rule in
                    RuleRow(rule: rule)
                }
            }
        }
        .onAppear {
            Task {
                await rulesManager.loadRules()
                await rulesManager.getMode()
            }
        }
    }
}

struct RuleRow: View {
    let rule: ProxyRule
    
    var body: some View {
        HStack {
            // Rule type badge
            Text(rule.type)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(ruleTypeColor.opacity(0.2))
                .foregroundColor(ruleTypeColor)
                .cornerRadius(4)
                .frame(minWidth: 120, alignment: .leading)
            
            // Payload
            Text(rule.payload)
                .font(.body)
                .lineLimit(1)
            
            Spacer()
            
            // Proxy
            HStack(spacing: 4) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.blue)
                    .font(.caption)
                Text(rule.proxy)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(4)
        }
        .padding(.vertical, 4)
        .contextMenu {
            Button("Copy Rule") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString("\(rule.type),\(rule.payload),\(rule.proxy)", forType: .string)
            }
            Button("Copy Payload") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(rule.payload, forType: .string)
            }
        }
    }
    
    private var ruleTypeColor: Color {
        switch rule.type {
        case "DOMAIN":
            return .blue
        case "DOMAIN-SUFFIX":
            return .cyan
        case "DOMAIN-KEYWORD":
            return .indigo
        case "IP-CIDR", "IP-CIDR6":
            return .green
        case "GEOIP":
            return .orange
        case "PROCESS-NAME":
            return .purple
        case "MATCH":
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    RulesDetailView()
}
