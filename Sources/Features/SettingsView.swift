import SwiftUI

struct SettingsView: View {
    @Binding var profile: FINDROnboardingProfile
    let onNotifications: () -> Void
    let onHelp: () -> Void
    let onLogout: () -> Void
    let onWithdraw: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var isEditingProfile = false
    @State private var unavailableDocument: String?

    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "설정", onBack: { dismiss() })
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    section("계정") {
                        row("로그인 계정", icon: "Figma_254d1", value: "카카오") {
                            unavailableDocument = "로그인 계정"
                        }
                        row("프로필 수정", icon: "Figma_1093f") { isEditingProfile = true }
                    }
                    section("알림") {
                        row("알림 설정", icon: "Figma_93682", action: onNotifications)
                    }
                    section("정보") {
                        row("앱 버전", icon: "Figma_1c77b", value: "1.0.0") { unavailableDocument = "앱 버전 1.0.0" }
                        row("이용약관", icon: "Figma_e6174") { unavailableDocument = "이용약관" }
                        row("개인정보처리방침", icon: "Figma_f1fee") { unavailableDocument = "개인정보처리방침" }
                        row("문의하기", icon: "Figma_431cf", action: onHelp)
                    }
                    VStack(spacing: 8) {
                        row("로그아웃", icon: "Figma_fd461", action: onLogout)
                            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16))
                        Button("회원 탈퇴", action: onWithdraw)
                            .font(FINDRFont.regular(12)).kerning(-0.24).underline()
                            .foregroundStyle(FINDRColor.tertiaryText).frame(height: 17).padding(.vertical, 12)
                    }
                }.padding(.horizontal, 20).padding(.top, 8)
            }
        }
        .background(FINDRColor.canvas).toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $isEditingProfile) { MyProfileEditorView(profile: $profile) {} }
        .alert(unavailableDocument ?? "", isPresented: Binding(
            get: { unavailableDocument != nil }, set: { if !$0 { unavailableDocument = nil } }
        )) { Button("확인", role: .cancel) {} } message: {
            Text(unavailableDocument == "로그인 계정" ? "아직 로그인된 계정이 없어요." : unavailableDocument == "앱 버전 1.0.0" ? "현재 앱 버전은 1.0.0이에요." : "현재 문서를 제공할 수 없어요.")
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(FINDRFont.bold(12)).foregroundStyle(FINDRColor.tertiaryText).frame(height: 17)
            VStack(spacing: 0, content: content)
                .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private func row(_ title: String, icon: String, value: String = "", action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon).resizable().frame(width: 20, height: 20)
                Text(title).font(FINDRFont.medium(14)).kerning(-0.28).foregroundStyle(FINDRColor.primaryText)
                Spacer(minLength: 4)
                if !value.isEmpty { Text(value).font(FINDRFont.regular(13)).kerning(-0.26).foregroundStyle(FINDRColor.tertiaryText) }
                Image("Figma_6f7ff").resizable().frame(width: 16, height: 16)
            }.padding(.horizontal, 16).frame(height: 44).contentShape(Rectangle())
        }.buttonStyle(.plain)
    }
}
