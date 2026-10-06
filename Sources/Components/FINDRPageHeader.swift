import SwiftUI

struct FINDRIconButton: View {
    let iconName: String
    let accessibilityLabel: String
    let action: () -> Void
    var size: CGFloat = 22
    var tint: Color = FINDRColor.secondaryText

    var body: some View {
        Button(action: action) {
            FINDRIcon(name: iconName, size: size, tint: tint)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct FINDRPageHeader: View {
    let title: String
    let trailingIcon: String
    let trailingLabel: String
    let action: () -> Void
    var titleKerning: CGFloat = 0
    var trailingSize: CGFloat = 22
    var trailingTint: Color = FINDRColor.secondaryText

    var body: some View {
        HStack {
            Text(title)
                .font(FINDRFont.title)
                .kerning(titleKerning)
                .foregroundStyle(FINDRColor.primaryText)
            Spacer()
            FINDRIconButton(
                iconName: trailingIcon,
                accessibilityLabel: trailingLabel,
                action: action,
                size: trailingSize,
                tint: trailingTint
            )
        }
    }
}
