import SwiftUI

struct FINDRProfileSetupProgressView: View {
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            Text("\(page)/4")
                .font(FINDRFont.bold(12))
                .foregroundStyle(FINDRColor.brand)

            FINDRProgressBar(progress: Double(page) / 4, color: FINDRColor.brandButton, height: 6)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("프로필 입력 진행률, \(page)/4단계")
    }
}
