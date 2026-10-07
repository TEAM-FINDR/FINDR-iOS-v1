import SwiftUI

struct FINDRProfileStatusOptionRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(FINDRFont.medium(15))
                    .tracking(-0.3)
                    .foregroundStyle(isSelected ? FINDRColor.brand : FINDRColor.primaryText)
                Spacer()
                radioIndicator
            }
            .padding(.horizontal, FINDRSpacing.large)
            .frame(height: isSelected ? 57 : 56)
            .background(
                isSelected ? FINDRColor.brandSubtle : Color.white,
                in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                    .stroke(isSelected ? FINDRColor.brandButton : FINDRColor.border, lineWidth: isSelected ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var radioIndicator: some View {
        if isSelected {
            Image(FINDRAssetName.profileStatusSelectedRadio)
                .resizable()
                .frame(width: 22, height: 22)
                .accessibilityHidden(true)
        } else {
            Circle()
                .stroke(FINDRColor.borderStrong, lineWidth: 1.5)
                .frame(width: 22, height: 22)
                .accessibilityHidden(true)
        }
    }
}
