import SwiftUI

struct FINDROnboardingResultHeaderView: View {
    let profile: FINDROnboardingProfile

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            Text("시우님을 위한\n기회를 찾았어요")
                .font(FINDRFont.titleLarge)
                .tracking(-0.52)
                .lineSpacing(-8)
                .offset(y: 4)
                .foregroundStyle(Color(hex: 0x0E1A3A))
                .fixedSize(horizontal: false, vertical: true)

            Text(profileSummary)
                .font(FINDRFont.regular(13))
                .tracking(-0.26)
                .foregroundStyle(FINDRColor.secondaryText)
                .lineLimit(2)
        }
    }

    private var profileSummary: String {
        let interests = profile.orderedInterests.joined(separator: "/")
        let region = profile.region.replacingOccurrences(of: "광주광역시", with: "광주")
        return "\(profile.age)세 · \(region) · \(profile.status) · \(interests)"
    }
}
