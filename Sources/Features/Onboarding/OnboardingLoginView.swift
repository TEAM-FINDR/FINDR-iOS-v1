import SwiftUI

struct FINDROnboardingLoginView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            Spacer(minLength: 0)

            FINDROnboardingLoginHeaderView()

            Spacer(minLength: 220)

            VStack(spacing: FINDRSpacing.small) {
                FINDROnboardingSocialLoginButton(provider: .apple, action: onContinue)
                FINDROnboardingSocialLoginButton(provider: .kakao, action: onContinue)
                FINDROnboardingSocialLoginButton(provider: .google, action: onContinue)
            }

            FINDROnboardingLegalNoticeView()
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white.ignoresSafeArea())
    }
}
