import SwiftUI

struct FINDROnboardingAnalysisHeaderView: View {
    var body: some View {
        VStack(spacing: FINDRSpacing.large) {
            Circle()
                .fill(FINDRColor.brandSubtle)
                .frame(width: 96, height: 96)
                .overlay {
                    FINDRIcon(name: FINDRAssetName.sparkles, size: 40, tint: FINDRColor.brandButton)
                }

            VStack(spacing: FINDRSpacing.small) {
                Text("조건을 분석하고 있어요")
                    .font(FINDRFont.title)
                    .tracking(-0.44)
                    .foregroundStyle(Color(hex: 0x0E1A3A))

                Text("1,200개의 기회와 시우님의 조건을 비교하는 중…")
                    .font(FINDRFont.regular(13))
                    .tracking(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
