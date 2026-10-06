import SwiftUI

struct FINDROnboardingAnalysisChecklistView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            FINDROnboardingAnalysisChecklistRowView(
                title: "연령 조건 확인",
                icon: FINDRAssetName.checkCircle,
                tint: FINDRColor.brandButton
            )
            FINDROnboardingAnalysisChecklistRowView(
                title: "지역 조건 확인",
                icon: FINDRAssetName.checkCircle,
                tint: FINDRColor.brandButton
            )
            FINDROnboardingAnalysisChecklistRowView(
                title: "관심 분야 매칭",
                icon: FINDRAssetName.clock,
                tint: FINDRColor.warningStatus
            )
        }
        .padding(.top, FINDRSpacing.medium)
    }
}
