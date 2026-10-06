import SwiftUI

struct FINDROnboardingResultMetricRowView: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color
    let valueColor: Color

    var body: some View {
        HStack(spacing: FINDRSpacing.medium) {
            FINDRIcon(name: icon, size: 22, tint: tint)
            Text(title)
                .font(FINDRFont.medium(15))
                .tracking(-0.3)
                .foregroundStyle(FINDRColor.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: FINDRSpacing.small)
            Text(value)
                .font(FINDRFont.bold(28))
                .tracking(-0.56)
                .foregroundStyle(valueColor)
                .fixedSize()
        }
        .accessibilityElement(children: .combine)
    }
}
