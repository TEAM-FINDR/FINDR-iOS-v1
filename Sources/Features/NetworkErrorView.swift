import SwiftUI

struct NetworkErrorView: View {
    let onRetry: () -> Void
    var body: some View {
        FINDREmptyState(icon: "Figma_83649", title: "인터넷 연결이 불안정해요",
                       message: "연결 상태를 확인한 뒤 다시 시도해주세요. 저장한 기회는 오프라인에서도 볼 수 있어요.",
                       actionTitle: "다시 시도", action: onRetry)
            .frame(maxWidth: .infinity, maxHeight: .infinity).padding(.bottom, 80)
            .background(FINDRColor.surface)
    }
}

struct NetworkErrorToastOverlay: View {
    let onRetry: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack(spacing: 8) {
                Image("Figma_2f8f2").resizable().frame(width: 20, height: 20)
                Text("네트워크 연결을 확인해주세요").font(FINDRFont.medium(13)).kerning(-0.26)
                    .foregroundStyle(FINDRColor.inverseSecondary).frame(maxWidth: .infinity, alignment: .leading)
                Button("재시도", action: onRetry).font(FINDRFont.bold(13)).kerning(-0.26).foregroundStyle(Color(hex: 0x7FA6FF))
            }.buttonStyle(.plain).padding(.horizontal, 16).frame(height: 44)
                .background(FINDRColor.inverse, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20).padding(.bottom, 100)
        }.ignoresSafeArea()
    }
}
