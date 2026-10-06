import SwiftUI
import UIKit

struct FINDRProfileSetupInputFieldView: View {
    let title: String
    var helper: String? = nil
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var isAccent = false

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.xSmall) {
            Text(title)
                .font(FINDRFont.medium(12))
                .foregroundStyle(FINDRColor.secondaryText)
                .frame(height: 17, alignment: .leading)

            TextField(title, text: $text)
                .font(FINDRFont.regular(15))
                .kerning(-0.3)
                .foregroundStyle(FINDRColor.primaryText)
                .keyboardType(keyboard)
                .padding(.horizontal, FINDRSpacing.large)
                .frame(height: 47)
                .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                        .stroke(isAccent ? FINDRColor.brandButton : FINDRColor.borderStrong, lineWidth: isAccent ? 1.5 : 1)
                }

            if let helper {
                Text(helper)
                    .font(FINDRFont.regular(11))
                    .foregroundStyle(FINDRColor.tertiaryText)
            }
        }
    }
}
