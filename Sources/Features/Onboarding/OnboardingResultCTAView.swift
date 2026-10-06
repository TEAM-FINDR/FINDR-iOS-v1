import SwiftUI

struct FINDROnboardingResultCTAView: View {
    let action: () -> Void

    var body: some View {
        FINDRButton(title: "홈으로 가기", action: action)
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, FINDRSpacing.small)
            .padding(.bottom, 16)
    }
}
