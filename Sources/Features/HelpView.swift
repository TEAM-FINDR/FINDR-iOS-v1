import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var expanded: Int? = 0
    @State private var contactUnavailable = false
    private let questions = ["지원 가능 여부는 어떻게 판단하나요?", "공고 정보가 실제와 달라요", "A-Path 추천 기준이 궁금해요", "알림이 오지 않아요", "회원 탈퇴는 어떻게 하나요?"]
    private let answers = [
        "AI가 공고문의 조건을 구조화하고, 실제 판단은 프로필과 조건을 비교하는 규칙 엔진이 해요. 최종 자격은 원문 공고를 꼭 확인해주세요.",
        "공고의 원문 링크에서 최신 정보를 확인해주세요. 앱의 신고 메뉴로 잘못된 정보를 알려주세요.",
        "보유 조건과 기회의 지원 조건을 비교해 준비할 활동을 안내해요.",
        "앱의 알림 설정과 기기의 설정에서 알림 허용 여부를 확인해주세요.",
        "MY의 설정에서 회원 탈퇴를 선택할 수 있어요. 현재 계정 삭제 서비스는 연결되어 있지 않아요."
    ]
    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "도움말", onBack: { dismiss() })
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("자주 묻는 질문").font(FINDRFont.bold(17)).kerning(-0.34).frame(height: 24)
                    VStack(spacing: 16) {
                        ForEach(questions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                Button { expanded = expanded == index ? nil : index } label: {
                                    HStack(spacing: 8) {
                                        Text("Q").font(FINDRFont.bold(14)).kerning(-0.28).foregroundStyle(FINDRColor.brand).frame(width: 11, height: 19)
                                        Text(questions[index]).font(FINDRFont.medium(14)).kerning(-0.28).foregroundStyle(FINDRColor.primaryText)
                                        Spacer(minLength: 0)
                                        Image(expanded == index ? "Figma_9d2ee" : "Figma_e20f9").resizable().frame(width: 16, height: 16)
                                    }.frame(height: 20)
                                }.buttonStyle(.plain)
                                if expanded == index {
                                    FINDRParagraph(text: answers[index])
                                        .frame(maxWidth: .infinity, alignment: .leading).padding(12)
                                        .background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 12))
                                }
                            }.padding(.vertical, 16).padding(.bottom, 1)
                                .overlay(alignment: .bottom) { FINDRColor.divider.frame(height: 1) }
                        }
                    }
                    VStack(alignment: .center, spacing: 8) {
                        Text("원하는 답을 찾지 못했나요?").font(FINDRFont.bold(14)).kerning(-0.28).frame(height: 19)
                        Text("평일 10:00–18:00 · 1일 이내 답변").font(FINDRFont.regular(12)).kerning(-0.24).foregroundStyle(FINDRColor.tertiaryText).frame(height: 17)
                        Button { contactUnavailable = true } label: {
                            Text("1:1 문의하기").font(FINDRFont.bold(15)).foregroundStyle(FINDRColor.primaryText)
                                .frame(maxWidth: .infinity).frame(height: 55)
                                .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12))
                                .overlay { RoundedRectangle(cornerRadius: 12).stroke(FINDRColor.borderStrong, lineWidth: 1) }
                        }.buttonStyle(.plain)
                    }.padding(16).background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 16)).padding(.top, 20)
                }.padding(.horizontal, 20).padding(.top, 8)
            }
        }.foregroundStyle(FINDRColor.primaryText).background(FINDRColor.surface).toolbar(.hidden, for: .navigationBar)
            .alert("문의 채널 미연결", isPresented: $contactUnavailable) { Button("확인", role: .cancel) {} } message: { Text("현재 문의 접수 채널이 연결되어 있지 않아요.") }
    }
}
