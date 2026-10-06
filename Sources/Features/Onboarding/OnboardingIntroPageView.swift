import SwiftUI

struct FINDROnboardingIntroPageView: View {
    let page: Int
    let content: FINDROnboardingIntroPageContent
    let onSkip: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            FINDROnboardingIntroTopBarView(onSkip: onSkip)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.section) {
                    FINDROnboardingIntroHeroView(content: content)
                    FINDROnboardingIntroCopyView(content: content)
                    FINDROnboardingIntroPaginationView(page: page)
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.large)
            }

            FINDROnboardingIntroCTAView(title: content.buttonTitle, action: onContinue)
        }
        .background(Color.white.ignoresSafeArea())
    }
}
