import Foundation
import UIKit

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

    static func saveProfilePhoto(_ data: Data) -> String? {
        guard let image = UIImage(data: data),
              let jpegData = image.jpegData(compressionQuality: 0.85),
              let supportDirectory = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
              ).first else {
            return nil
        }

        let directory = supportDirectory.appendingPathComponent("FINDR", isDirectory: true)
        let photoURL = directory.appendingPathComponent("profile-avatar.jpg")
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            try jpegData.write(to: photoURL, options: .atomic)
            return "profile-avatar.jpg"
        } catch {
            return nil
        }
    }

    static func profilePhotoURL(for path: String?) -> URL? {
        guard let path,
              let supportDirectory = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
              ).first else {
            return nil
        }
        return supportDirectory
            .appendingPathComponent("FINDR", isDirectory: true)
            .appendingPathComponent(path)
    }
}
