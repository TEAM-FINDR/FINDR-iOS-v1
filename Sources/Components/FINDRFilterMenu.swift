import SwiftUI

struct FINDRFilterMenu: View {
    let title: String
    let selectedOption: String?
    let resetOption: String
    let options: [String]
    let onSelect: (String) -> Void

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
            HStack(spacing: 3) {
                Text(label)
                    .font(FINDRFont.regular(11))
                FINDRIcon(name: FINDRAssetName.chevronDown, size: 12, tint: FINDRColor.secondaryText)
            }
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.horizontal, 9)
            .frame(height: 32)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(FINDRColor.borderStrong, lineWidth: 1))
        }
        .menuStyle(.borderlessButton)
    }
}
