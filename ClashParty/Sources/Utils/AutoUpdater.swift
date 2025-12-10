//
//  AutoUpdater.swift
//  ClashParty
//
//  Auto-update functionality using GitHub releases
//

import Foundation

struct Release: Codable {
    let tagName: String
    let name: String
    let body: String
    let publishedAt: String
    let assets: [ReleaseAsset]
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case name
        case body
        case publishedAt = "published_at"
        case assets
    }
}

struct ReleaseAsset: Codable {
    let name: String
    let browserDownloadURL: String
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case browserDownloadURL = "browser_download_url"
        case size
    }
}

@MainActor
class AutoUpdater: ObservableObject {
    static let shared = AutoUpdater()
    
    @Published var updateAvailable = false
    @Published var latestRelease: Release?
    @Published var isChecking = false
    
    private let githubRepo = "mihomo-party-org/clash-party"
    private let currentVersion = "1.8.9"
    
    private init() {}
    
    func checkForUpdates() async {
        guard !isChecking else { return }
        
        isChecking = true
        defer { isChecking = false }
        
        Logger.shared.info("Checking for updates...")
        
        guard let url = URL(string: "https://api.github.com/repos/\(githubRepo)/releases/latest") else {
            Logger.shared.error("Invalid GitHub API URL")
            return
        }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let release = try JSONDecoder().decode(Release.self, from: data)
            
            latestRelease = release
            
            // Compare versions
            let latestVersion = release.tagName.replacingOccurrences(of: "v", with: "")
            if compareVersions(latestVersion, currentVersion) == .orderedDescending {
                updateAvailable = true
                Logger.shared.info("Update available: \(release.tagName)")
            } else {
                Logger.shared.info("Already on the latest version")
            }
        } catch {
            Logger.shared.error("Failed to check for updates: \(error.localizedDescription)")
        }
    }
    
    func downloadUpdate() async throws -> URL {
        guard let release = latestRelease,
              let asset = release.assets.first(where: { $0.name.contains("macos") && $0.name.hasSuffix(".dmg") }) else {
            throw NSError(domain: "AutoUpdater", code: 1, userInfo: [NSLocalizedDescriptionKey: "No suitable update found"])
        }
        
        Logger.shared.info("Downloading update from: \(asset.browserDownloadURL)")
        
        guard let url = URL(string: asset.browserDownloadURL) else {
            throw NSError(domain: "AutoUpdater", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid download URL"])
        }
        
        let (downloadURL, _) = try await URLSession.shared.download(from: url)
        
        // Move to permanent location
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(asset.name)
        try? FileManager.default.removeItem(at: destinationURL)
        try FileManager.default.moveItem(at: downloadURL, to: destinationURL)
        
        Logger.shared.info("Update downloaded to: \(destinationURL.path)")
        return destinationURL
    }
    
    private func compareVersions(_ v1: String, _ v2: String) -> ComparisonResult {
        let v1Parts = v1.split(separator: ".").compactMap { Int($0) }
        let v2Parts = v2.split(separator: ".").compactMap { Int($0) }
        
        let maxLength = max(v1Parts.count, v2Parts.count)
        
        for i in 0..<maxLength {
            let part1 = i < v1Parts.count ? v1Parts[i] : 0
            let part2 = i < v2Parts.count ? v2Parts[i] : 0
            
            if part1 < part2 {
                return .orderedAscending
            } else if part1 > part2 {
                return .orderedDescending
            }
        }
        
        return .orderedSame
    }
}
