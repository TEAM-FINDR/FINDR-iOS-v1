import SwiftUI

struct FINDRProfileStatusOptionRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(FINDRFont.medium(14))
                    .foregroundStyle(isSelected ? FINDRColor.brandButton : FINDRColor.primaryText)
                Spacer()
                radioIndicator
            }
            .padding(.horizontal, FINDRSpacing.large)
            .frame(height: 56)
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

    private var radioIndicator: some View {
        Circle()
            .stroke(isSelected ? FINDRColor.brandButton : FINDRColor.borderStrong, lineWidth: isSelected ? 6 : 1.5)
            .frame(width: 20, height: 20)
            .overlay {
                if isSelected {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                }
            }
            .accessibilityHidden(true)
    }
}
