import SwiftUI
import UIKit

struct FINDRProfileSetupInputFieldView: View {
    let title: String
    let helper: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var isAccent = false

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.xSmall) {
            Text(title)
                .font(FINDRFont.medium(12))
                .foregroundStyle(FINDRColor.secondaryText)

            TextField(title, text: $text)
                .font(FINDRFont.regular(15))
                .foregroundStyle(FINDRColor.primaryText)
                .keyboardType(keyboard)
                .padding(.horizontal, FINDRSpacing.large)
                .frame(height: 48)
                .background(Color.white, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                        .stroke(isAccent ? FINDRColor.brandButton : FINDRColor.borderStrong, lineWidth: isAccent ? 1.5 : 1)
                }

            Text(helper)
                .font(FINDRFont.regular(11))
                .foregroundStyle(FINDRColor.tertiaryText)
        }
    }
}
