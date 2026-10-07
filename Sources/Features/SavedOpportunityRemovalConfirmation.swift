import SwiftUI

struct SavedOpportunityRemovalConfirmationOverlay: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onCancel)
                    .accessibilityLabel("저장 취소 확인 창 닫기")
                    .accessibilityAddTraits(.isButton)

                confirmationCard
                    .frame(width: 320, height: 229)
                    .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("saved-removal-confirmation")
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }

    private var confirmationCard: some View {
        VStack(spacing: 16) {
            Image(FINDRAssetName.savedRemovalAlert)
                .resizable()
                .frame(width: 24, height: 24)
                .frame(width: 48, height: 48)
                .background(FINDRColor.dangerSubtle, in: Circle())
                .accessibilityHidden(true)

            VStack(spacing: 4) {
                Text("저장을 취소할까요?")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .multilineTextAlignment(.center)

                Text("저장 목록에서 사라지고 마감 알림도 함께 꺼져요.")
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text("취소")
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(FINDRColor.borderStrong, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Button(action: onConfirm) {
                    Text("저장 취소")
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(FINDRColor.danger, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .offset(y: -2)
        }
        .padding(24)
        .frame(width: 320, height: 229)
    }
}
