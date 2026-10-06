import SwiftUI

struct MyProfileSaveConfirmationView: View {
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: FINDRSpacing.large) {
                Circle()
                    .fill(FINDRColor.brandSubtle)
                    .frame(width: 48, height: 48)
                    .overlay {
                        FINDRIcon(name: FINDRAssetName.checkCircle, size: 24, tint: FINDRColor.brandButton)
                    }

                VStack(spacing: FINDRSpacing.xSmall) {
                    Text("프로필이 저장되었어요")
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(height: 24)
                    Text("변경된 조건으로 기회를 다시 계산했어요. 새로 지원 가능한 기회가 2개 생겼어요.")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .frame(height: 36)
                }

                FINDRButton(title: "확인", height: 53, action: onConfirm)
            }
            .padding(24)
            .frame(width: 320, height: 245)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
        }
        .ignoresSafeArea()
        .accessibilityAddTraits(.isModal)
    }
}
