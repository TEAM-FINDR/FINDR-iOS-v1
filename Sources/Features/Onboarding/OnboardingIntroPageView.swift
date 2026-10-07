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
                VStack(alignment: .leading, spacing: 0) {
                    FINDROnboardingIntroHeroView(content: content)
                        .padding(.bottom, FINDRSpacing.section - 4)
                    FINDROnboardingIntroCopyView(content: content)
                        .padding(.bottom, FINDRSpacing.section - 1)
                    FINDROnboardingIntroPaginationView(page: page)
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.large)
            }

            FINDROnboardingIntroCTAView(title: content.buttonTitle, action: onContinue)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.white.ignoresSafeArea())
    }
}
