//
//  ProfileManager.swift
//  ClashParty
//
//  Profile data model and management
//

import Foundation

struct Profile: Codable, Identifiable {
    let id: UUID
    var name: String
    var url: String?
    var isActive: Bool
    var updatedAt: Date
    var content: String?
    
    init(id: UUID = UUID(), name: String, url: String?, isActive: Bool = false, updatedAt: Date = Date(), content: String? = nil) {
        self.id = id
        self.name = name
        self.url = url
        self.isActive = isActive
        self.updatedAt = updatedAt
        self.content = content
    }
}

extension Profile {
    var isSubscription: Bool {
        return url != nil && !url!.isEmpty
    }
    
    var displayURL: String {
        return url ?? "Local Profile"
    }
    
    func formattedUpdateTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: updatedAt, relativeTo: Date())
    }
}
