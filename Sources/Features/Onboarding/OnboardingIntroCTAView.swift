import SwiftUI

struct FINDROnboardingIntroCTAView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        FINDRButton(title: title, action: action)
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, FINDRSpacing.medium)
            .padding(.bottom, 29)
    }
}
