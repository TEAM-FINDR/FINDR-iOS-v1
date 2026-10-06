import SwiftUI

struct FINDRProfileSetupTitleView: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            Text(title)
                .font(FINDRFont.titleLarge)
                .tracking(-0.52)
                .lineSpacing(0)
                .foregroundStyle(Color(hex: 0x0E1A3A))
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle {
                Text(subtitle)
                    .font(FINDRFont.regular(13))
                    .tracking(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
