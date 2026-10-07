import SwiftUI

struct FINDROnboardingIntroPageContent {
    let gradient: [Color]
    let badge: String
    let title: String
    let description: String
    let icon: Icon
    let buttonTitle: String
    var usesPillBadge = false

    enum Icon: Equatable {
        case sparkles
        case checkCircle
        case unlock

        var assetName: String {
            switch self {
            case .sparkles: FINDRAssetName.sparkles
            case .checkCircle: FINDRAssetName.onboardingCheckCircle
            case .unlock: FINDRAssetName.unlock
            }
        }

        var usesTemplate: Bool {
            self != .sparkles && self != .checkCircle
        }
    }
}
