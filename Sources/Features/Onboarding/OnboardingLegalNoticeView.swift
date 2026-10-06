import SwiftUI

struct FINDROnboardingLegalNoticeView: View {
    var body: some View {
        Text("가입 시 이용약관 및 개인정보처리방침에 동의하게 됩니다.")
            .font(FINDRFont.regular(12))
            .tracking(-0.24)
            .foregroundStyle(FINDRColor.tertiaryText)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}
