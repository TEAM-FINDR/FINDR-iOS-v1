import SwiftUI

struct FINDROnboardingResultMetricsCardView: View {
    var body: some View {
        VStack(spacing: FINDRSpacing.large) {
            FINDROnboardingResultMetricRowView(
                title: "지금 지원 가능",
                value: "29개",
                icon: FINDRAssetName.onboardingResultCheckCircle,
                valueColor: FINDRColor.brandButton
            )
            FINDROnboardingResultMetricRowView(
                title: "조금만 더 하면 가능",
                value: "7개",
                icon: FINDRAssetName.onboardingResultClock,
                valueColor: FINDRColor.warning
            )
            FINDROnboardingResultMetricRowView(
                title: "준비하면 열리는 기회",
                value: "+87개",
                icon: FINDRAssetName.onboardingResultUnlock,
                valueColor: FINDRColor.success
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: 0xF6F7FB), in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
    }
}
