import Foundation
import Combine

struct AppUpdateRelease: Identifiable {
    let tagName: String
    let title: String
    let htmlURL: URL
    let buildNumber: Int

    var id: String { tagName }
}

@MainActor
final class UpdateChecker: ObservableObject {
    @Published private(set) var availableRelease: AppUpdateRelease?
    @Published private(set) var isChecking = false
    @Published private(set) var statusMessage = ""
    @Published var showAlert = false

    private var currentBuild: Int {
        Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
    }

    func checkForUpdates(silent: Bool = false) async {
        guard !isChecking else { return }
        isChecking = true
        defer { isChecking = false }

        do {
            let endpoint = URL(string: "https://api.github.com/repos/doorsfan14/iClassicMsg/releases?per_page=30")!
            var request = URLRequest(url: endpoint)
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.setValue("iClassicMsg-iOS", forHTTPHeaderField: "User-Agent")
            request.timeoutInterval = 15

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw UpdateCheckError.invalidResponse
            }

            let releases = try JSONDecoder().decode([GitHubRelease].self, from: data)
            let newest = releases
                .compactMap { release -> (release: GitHubRelease, build: Int)? in
                    guard release.prerelease,
                          let build = Self.buildNumber(from: release.tag_name),
                          release.assets.contains(where: { $0.name.lowercased().hasSuffix(".ipa") }) else {
                        return nil
                    }
                    return (release, build)
                }
                .max { $0.build < $1.build }

            guard let newest,
                  let releaseURL = URL(string: newest.release.html_url) else {
                availableRelease = nil
                statusMessage = "No published iOS builds were found. Try again after the next successful main-branch build."
                if !silent { showAlert = true }
                return
            }

            if newest.build > currentBuild {
                availableRelease = AppUpdateRelease(
                    tagName: newest.release.tag_name,
                    title: newest.release.name ?? newest.release.tag_name,
                    htmlURL: releaseURL,
                    buildNumber: newest.build
                )
                statusMessage = "iClassicMsg build \(newest.build) is available. Open the GitHub release to get the IPA, then install it with your usual sideloading tool."
                if !silent { showAlert = true }
            } else {
                availableRelease = nil
                statusMessage = "You're using the latest available iClassicMsg build."
                if !silent { showAlert = true }
            }
        } catch {
            statusMessage = "Couldn't check GitHub right now. Check your connection and try again."
            if !silent { showAlert = true }
        }
    }

    private static func buildNumber(from tag: String) -> Int? {
        guard tag.hasPrefix("ios-build-") else { return nil }
        return Int(tag.dropFirst("ios-build-".count))
    }
}

private struct GitHubRelease: Decodable {
    let tag_name: String
    let name: String?
    let html_url: String
    let prerelease: Bool
    let assets: [GitHubReleaseAsset]
}

private struct GitHubReleaseAsset: Decodable {
    let name: String
}

private enum UpdateCheckError: Error {
    case invalidResponse
}
