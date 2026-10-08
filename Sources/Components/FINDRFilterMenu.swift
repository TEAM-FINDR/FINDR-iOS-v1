import SwiftUI

struct FINDRFilterMenu: View {
    let title: String
    let selectedOption: String?
    let action: () -> Void
    var width: CGFloat? = nil

    private var label: String {
        guard let selectedOption, selectedOption != "전체" else { return title }
        return selectedOption
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Text(label)
                    .font(FINDRFont.medium(12))
                    .kerning(-0.24)
                    .lineLimit(1)
                FINDRIcon(name: FINDRAssetName.chevronDown, size: 14, tint: FINDRColor.secondaryText)
            }
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.leading, 11)
            .padding(.trailing, 9)
            .frame(width: selectedOption == nil ? width : nil, height: 31)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(FINDRColor.borderStrong, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(selectedOption ?? "전체")
        .accessibilityHint("필터를 엽니다")
    }
}
