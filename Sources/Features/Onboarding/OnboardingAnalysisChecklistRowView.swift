import SwiftUI

struct FINDROnboardingAnalysisChecklistRowView: View {
    let title: String
    let icon: String
    let textColor: Color

    var body: some View {
        HStack(spacing: FINDRSpacing.small) {
            FINDRIcon(name: icon, size: 20, usesTemplate: false)
            Text(title)
                .font(FINDRFont.regular(14))
                .tracking(-0.28)
                .foregroundStyle(textColor)
        }
    }
}
