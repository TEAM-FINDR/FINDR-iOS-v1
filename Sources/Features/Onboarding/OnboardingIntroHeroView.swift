import SwiftUI

struct FINDROnboardingIntroHeroView: View {
    let content: FINDROnboardingIntroPageContent

    var body: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(LinearGradient(colors: content.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 320)
            .overlay(alignment: .topLeading) {
                badge
                    .padding(24)
            }
            .overlay {
                FINDRIcon(
                    name: content.icon.assetName,
                    size: 96,
                    tint: .white,
                    usesTemplate: content.icon.usesTemplate
                )
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(content.badge)
    }

    @ViewBuilder
    private var badge: some View {
        if content.usesPillBadge {
            Text(content.badge)
                .font(FINDRFont.bold(13))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(FINDRColor.brandButton, in: Capsule())
        } else {
            FINDRTag(title: content.badge, tone: .brand, font: FINDRFont.regular(12))
        }
    }
}
