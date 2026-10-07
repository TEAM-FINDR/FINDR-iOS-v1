import SwiftUI

struct FINDROnboardingAnalysisChecklistView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            FINDROnboardingAnalysisChecklistRowView(
                title: "연령 조건 확인",
                icon: FINDRAssetName.onboardingAnalysisCheckCircle,
                textColor: FINDRColor.primaryText
            )
            FINDROnboardingAnalysisChecklistRowView(
                title: "지역 조건 확인",
                icon: FINDRAssetName.onboardingAnalysisCheckCircle,
                textColor: FINDRColor.primaryText
            )
            FINDROnboardingAnalysisChecklistRowView(
                title: "관심 분야 매칭",
                icon: FINDRAssetName.onboardingAnalysisClock,
                textColor: FINDRColor.tertiaryText
            )
        }
        .padding(.top, FINDRSpacing.medium)
    }
}
