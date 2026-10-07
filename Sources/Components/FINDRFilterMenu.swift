import SwiftUI

struct FINDRFilterMenu: View {
    let title: String
    let selectedOption: String?
    let resetOption: String
    let options: [String]
    let onSelect: (String) -> Void
    var width: CGFloat? = nil

    private var label: String {
        guard let selectedOption, selectedOption != resetOption else { return title }
        return selectedOption
    }

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    onSelect(option)
                }
            }
        } label: {
            HStack(spacing: 2) {
                Text(label)
                    .font(FINDRFont.medium(12))
                    .kerning(-0.24)
                FINDRIcon(name: FINDRAssetName.chevronDown, size: 14, tint: FINDRColor.secondaryText)
            }
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.leading, 11)
            .padding(.trailing, 9)
            .frame(width: selectedOption == nil ? width : nil, height: 31)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(FINDRColor.borderStrong, lineWidth: 1))
        }
        .menuStyle(.borderlessButton)
    }
}
