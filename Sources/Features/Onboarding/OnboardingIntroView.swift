import SwiftUI

struct FINDROnboardingIntroView: View {
    let page: Int
    let onSkip: () -> Void
    let onContinue: () -> Void

    private var content: FINDROnboardingIntroPageContent {
        switch page {
        case 2: .a3
        case 3: .a4
        default: .a2
        }
    }

    var body: some View {
        FINDROnboardingIntroPageView(
            page: page,
            content: content,
            onSkip: onSkip,
            onContinue: onContinue
        )
    }
}
