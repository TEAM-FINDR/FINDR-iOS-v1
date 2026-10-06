import SwiftUI

struct FINDRBackNavigationHeader: View {
    let title: String
    let onBack: () -> Void
    var trailingIconName: String? = nil
    var trailingAccessibilityLabel: String? = nil
    var onTrailing: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            FINDRIconButton(
                iconName: FINDRAssetName.back,
                accessibilityLabel: "뒤로",
                action: onBack,
                size: 24,
                tint: FINDRColor.primaryText
            )
            .frame(width: 64, height: 24, alignment: .leading)

            Text(title)
                .font(FINDRFont.bodyLargeBold)
                .kerning(-0.3)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(maxWidth: .infinity)

            Group {
                if let trailingIconName, let trailingAccessibilityLabel, let onTrailing {
                    FINDRIconButton(
                        iconName: trailingIconName,
                        accessibilityLabel: trailingAccessibilityLabel,
                        action: onTrailing,
                        size: 22,
                        tint: FINDRColor.primaryText
                    )
                }
            }
            .frame(width: 64, height: 24, alignment: .trailing)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.small + 6)
        .padding(.bottom, FINDRSpacing.small)
    }
}
