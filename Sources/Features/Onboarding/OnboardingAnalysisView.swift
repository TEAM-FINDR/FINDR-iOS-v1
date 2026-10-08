import SwiftUI

struct FINDRAnalyzingView: View {
    var body: some View {
        VStack(spacing: FINDRSpacing.large) {
            FINDROnboardingAnalysisHeaderView()
            FINDROnboardingAnalysisProgressView()
            FINDROnboardingAnalysisChecklistView()
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.small)
        .padding(.bottom, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .bottom)
        .offset(y: 3)
        .background(Color.white.ignoresSafeArea())
    }
}
