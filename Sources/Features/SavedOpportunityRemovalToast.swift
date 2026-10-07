import SwiftUI

struct SavedOpportunityRemovalToastOverlay: View {
    let onUndo: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            toast
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
        }
        .ignoresSafeArea()
        .accessibilityIdentifier("saved-removal-undo-toast")
    }

    private var toast: some View {
        HStack(spacing: 8) {
            Image(FINDRAssetName.saveToastCheck)
                .resizable()
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)

            Text("저장을 취소했어요")
                .font(FINDRFont.medium(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.inverseSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onUndo) {
                Text("실행 취소")
                    .font(FINDRFont.bold(13))
                    .kerning(-0.26)
                    .foregroundStyle(Color(hex: 0x7FA6FF))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("saved-removal-undo")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(FINDRColor.inverse, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
    }
}
