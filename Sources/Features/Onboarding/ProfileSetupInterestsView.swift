import SwiftUI

struct FINDRProfileSetupInterestsView: View {
    @Binding var profile: FINDROnboardingProfile

    private let options = FINDROnboardingProfileOptions.myProfileInterests

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
                ForEach(options, id: \.self) { option in
                    FINDRPill(title: option, isSelected: profile.interests.contains(option)) {
                        toggle(option)
                    }
                }
            }

            Text("\(profile.interests.count)개 선택됨")
                .font(FINDRFont.medium(12))
                .foregroundStyle(FINDRColor.brand)
                .accessibilityLabel("관심 분야 \(profile.interests.count)개 선택됨")
        }
    }

    private func toggle(_ option: String) {
        profile.toggleInterest(option)
    }
}
