import SwiftUI

struct FINDRAnalyzingView: View {
    var body: some View {
        VStack(spacing: FINDRSpacing.large) {
            Spacer(minLength: 0)
            FINDROnboardingAnalysisHeaderView()
            FINDROnboardingAnalysisProgressView()
            FINDROnboardingAnalysisChecklistView()
            Spacer(minLength: 60)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}
