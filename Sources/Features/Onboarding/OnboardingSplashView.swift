import SwiftUI

struct FINDRSplashView: View {
    var body: some View {
        ZStack {
            Color(hex: 0x0E1A3A)
                .ignoresSafeArea()

            Image(FINDRAssetName.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .accessibilityLabel("FINDR")
        }
    }
}
