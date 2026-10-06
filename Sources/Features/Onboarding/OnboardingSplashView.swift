import SwiftUI

struct FINDRSplashView: View {
    var body: some View {
        ZStack {
            Color(hex: 0x0E1A3A)
                .ignoresSafeArea()

            VStack(spacing: FINDRSpacing.xSmall + 2) {
                VStack(spacing: 59) {
                    Image(FINDRAssetName.logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .accessibilityLabel("FINDR")

                    Text("Opportunity Compass")
                        .font(FINDRFont.medium(13))
                        .tracking(-0.26)
                        .foregroundStyle(FINDRColor.inverseSecondary)
                }

                Text("현재의 나와 미래의 기회를 연결한다")
                    .font(FINDRFont.regular(12))
                    .tracking(-0.24)
                    .foregroundStyle(FINDRColor.inverseSecondary)
            }
            .padding(.bottom, 80)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
