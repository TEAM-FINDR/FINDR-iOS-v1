import SwiftUI

struct FINDROnboardingLoginHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(FINDRAssetName.loginLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .padding(.bottom, 8)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: -3) {
                Text("현재의 나와")
                Text("미래의 기회를 연결해요")
            }
                .font(FINDRFont.titleLarge)
                .tracking(-0.52)
                .foregroundStyle(Color(hex: 0x0E1A3A))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 9)

            Text("3초 만에 시작하고\n지금 지원 가능한 기회를 확인하세요.")
                .font(FINDRFont.regular(15))
                .tracking(-0.3)
                .lineSpacing(-3)
                .foregroundStyle(FINDRColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 1)
        }
    }
}
