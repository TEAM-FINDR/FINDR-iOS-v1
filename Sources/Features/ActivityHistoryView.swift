import SwiftUI

struct ActivityHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    private let activities = [
        ("포트폴리오 완료", "새로운 기회 12개가 열렸어요", "10.01", "Figma_daee7"),
        ("신청 페이지 방문", "광주 청소년 AI 캠프", "09.28", "Figma_bf16b"),
        ("보유 조건 추가", "컴퓨터활용능력 2급", "09.25", "Figma_eae64"),
        ("기회 저장", "전국 고교생 앱 개발 해커톤", "09.22", "Figma_f00fd"),
        ("가입 완료", "AI와 함께한 첫날", "09.21", "Figma_9ee9d")
    ]
    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "활동 기록", onBack: { dismiss() })
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        statistic("12", "저장")
                        statistic("5", "신청 페이지 방문")
                        statistic("+20", "열린 기회", color: FINDRColor.success)
                    }
                    Text("최근 활동").font(FINDRFont.bold(17)).kerning(-0.34).frame(height: 24)
                    VStack(spacing: 16) {
                        ForEach(activities.indices, id: \.self) { index in
                            let item = activities[index]
                            HStack(spacing: 12) {
                                Image(item.3).resizable().frame(width: 16, height: 16)
                                    .frame(width: 32, height: 32)
                                    .background(index == 0 ? FINDRColor.successSubtle : index < 3 ? FINDRColor.brandSubtle : FINDRColor.canvas, in: Circle())
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.0).font(FINDRFont.bold(14)).kerning(-0.28)
                                    Text(item.1).font(FINDRFont.regular(12)).kerning(-0.24).foregroundStyle(FINDRColor.secondaryText)
                                }.frame(height: 38, alignment: .leading)
                                Spacer(minLength: 0)
                                Text(item.2).font(FINDRFont.regular(12)).foregroundStyle(FINDRColor.tertiaryText)
                            }
                        }
                    }.padding(16).background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16))
                }.padding(.horizontal, 20).padding(.top, 8)
            }
        }.foregroundStyle(FINDRColor.primaryText).background(FINDRColor.canvas).toolbar(.hidden, for: .navigationBar)
    }
    private func statistic(_ value: String, _ label: String, color: Color = FINDRColor.primaryText) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value).font(FINDRFont.bold(22)).kerning(-0.44).foregroundStyle(color).frame(height: 31)
            Text(label).font(FINDRFont.regular(12)).kerning(-0.24).foregroundStyle(FINDRColor.secondaryText).fixedSize().frame(height: 17)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(16)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16))
    }
}
