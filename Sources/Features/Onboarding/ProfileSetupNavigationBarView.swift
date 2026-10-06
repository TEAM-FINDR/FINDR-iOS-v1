import SwiftUI

struct FINDRProfileSetupNavigationBarView: View {
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                FINDRIcon(name: FINDRAssetName.back, size: 24, tint: FINDRColor.primaryText)
                    .frame(width: 64, height: 40, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로")

            Text("프로필 입력")
                .font(FINDRFont.bold(15))
                .tracking(-0.3)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(maxWidth: .infinity)

            Color.clear
                .frame(width: 64, height: 24)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.vertical, FINDRSpacing.small)
    }
}
