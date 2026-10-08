import SwiftUI

struct FINDRSearchField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            FINDRIcon(name: FINDRAssetName.search, size: 18, tint: FINDRColor.inactiveIcon)
            TextField(placeholder, text: $text)
                .font(FINDRFont.regular(13))
                .foregroundStyle(FINDRColor.primaryText)
                .tint(FINDRColor.brand)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
