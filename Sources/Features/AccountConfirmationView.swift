import SwiftUI

enum AccountConfirmation: String, Identifiable {
    case logout, withdrawal
    var id: String { rawValue }
}

struct AccountConfirmationOverlay: View {
    let kind: AccountConfirmation
    let onCancel: () -> Void
    let onConfirm: () -> Void
    var body: some View {
        ZStack {
            FINDRColor.scrim.opacity(0.45).ignoresSafeArea().onTapGesture(perform: onCancel)
            VStack(spacing: 16) {
                Image(kind == .logout ? "Figma_4d9d5" : "Figma_73837").resizable().frame(width: 24, height: 24)
                    .frame(width: 48, height: 48).background(kind == .logout ? FINDRColor.brandSubtle : FINDRColor.dangerSubtle, in: Circle())
                VStack(spacing: 4) {
                    Text(kind == .logout ? "로그아웃할까요?" : "정말 탈퇴하시겠어요?").font(FINDRFont.bold(17)).kerning(-0.34).foregroundStyle(FINDRColor.primaryText)
                    Text(kind == .logout ? "다시 로그인하면 저장한 기회와 보유 조건을 그대로\n볼 수 있어요." : "저장한 기회, 보유 조건, 활동 기록이 모두 삭제되며\n복구할 수 없어요.")
                        .font(FINDRFont.regular(13)).kerning(-0.26).foregroundStyle(FINDRColor.secondaryText)
                        .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                }
                HStack(spacing: 8) {
                    Button("취소", action: onCancel).foregroundStyle(FINDRColor.primaryText)
                        .frame(maxWidth: .infinity).frame(height: 54)
                        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12))
                        .overlay { RoundedRectangle(cornerRadius: 12).stroke(FINDRColor.borderStrong, lineWidth: 1) }
                    Button(kind == .logout ? "로그아웃" : "탈퇴하기", action: onConfirm).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).frame(height: 54)
                        .background(kind == .logout ? FINDRColor.brandButton : FINDRColor.danger, in: RoundedRectangle(cornerRadius: 12))
                }.font(FINDRFont.bold(15)).kerning(-0.3).buttonStyle(.plain)
            }.padding(24).frame(width: 320, height: 247)
                .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20))
        }.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
    }
}
