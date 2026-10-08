import SwiftUI

struct FINDREmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(icon).resizable().frame(width: 32, height: 32)
                .frame(width: 72, height: 72)
                .background(FINDRColor.subtle, in: Circle())
                .accessibilityHidden(true)
            Text(title).font(FINDRFont.bold(17)).kerning(-0.34).baselineOffset(1)
                .foregroundStyle(FINDRColor.primaryText).frame(height: 24)
            FINDRParagraph(text: message, alignment: .center)
                .frame(maxWidth: .infinity)
            Button(action: action) {
                Text(actionTitle).font(FINDRFont.bold(15)).kerning(-0.3)
                    .foregroundStyle(.white).frame(width: 180, height: 53)
                    .background(FINDRColor.brandButton, in: RoundedRectangle(cornerRadius: 12))
            }.buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

