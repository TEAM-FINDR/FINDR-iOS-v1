import Foundation

enum FINDRProfileStore {
    static let key = "FINDR.profile"

    static func load(from defaults: UserDefaults = .standard) -> FINDROnboardingProfile {
        guard let data = defaults.data(forKey: key),
              let profile = try? JSONDecoder().decode(FINDROnboardingProfile.self, from: data) else {
            return FINDROnboardingProfile()
        }
        return profile
    }

    static func save(_ profile: FINDROnboardingProfile, to defaults: UserDefaults = .standard) {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        defaults.set(data, forKey: key)
    }
}
