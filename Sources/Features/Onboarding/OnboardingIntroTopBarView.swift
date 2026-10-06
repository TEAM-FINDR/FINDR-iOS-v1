import SwiftUI

struct FINDROnboardingIntroTopBarView: View {
    let onSkip: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button("건너뛰기", action: onSkip)
                .font(FINDRFont.medium(13))
                .tracking(-0.26)
                .foregroundStyle(FINDRColor.tertiaryText)
                .buttonStyle(.plain)
                .accessibilityHint("로그인 화면으로 이동합니다.")
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.vertical, FINDRSpacing.small)
    }
}
