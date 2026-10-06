import SwiftUI

struct FINDROnboardingAnalysisChecklistRowView: View {
    let title: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: FINDRSpacing.small) {
            FINDRIcon(name: icon, size: 20, tint: tint)
            Text(title)
                .font(FINDRFont.regular(14))
                .tracking(-0.28)
                .foregroundStyle(FINDRColor.primaryText)
        }
    }
}
