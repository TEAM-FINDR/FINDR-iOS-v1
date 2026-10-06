import SwiftUI

struct APathView: View {
    @State private var selectedCategory = "추천 행동"
    @State private var showHelp = false

    private let categories = ["추천 행동", "자격증", "교육", "경험"]
    private let actions: [(String, String, String, Color)] = [
        ("포트폴리오 만들기", "IT·개발 분야 기회가 열려요", FINDRAssetName.file, Color(hex: 0xEAF1FF)),
        ("컴퓨터활용능력 2급 취득", "공공기관·대외활동 기회가 열려요", FINDRAssetName.monitor, Color(hex: 0xE7F8EF)),
        ("AI 관련 교육 수료", "교육·해커톤 기회가 열려요", FINDRAssetName.cpu, Color(hex: 0xFFF4E5)),
        ("프로젝트 경험 쌓기", "공모전 기회가 열려요", FINDRAssetName.rocket, FINDRColor.accentSubtle)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                whatIfCard
                Text("지금 할 수 있는 활동이 새로운 기회를 만들어요.")
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .padding(.top, 2)
                categoryTabs
                VStack(spacing: 8) {
                    ForEach(Array(actions.enumerated()), id: \.offset) { index, item in
                        actionCard(item, index: index)
                    }
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 14)
        }
        .background(FINDRColor.canvas)
        .alert("A-Path 안내", isPresented: $showHelp) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("추천 행동을 완료하면 지원 가능한 기회가 늘어납니다.")
        }
    }

    private var header: some View {
        HStack {
            Text("A-Path")
                .font(FINDRFont.title)
                .foregroundStyle(FINDRColor.primaryText)
            Spacer()
            Button { showHelp = true } label: {
                FINDRIcon(name: FINDRAssetName.help, size: 21, tint: FINDRColor.secondaryText)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("A-Path 도움말")
        }
    }

    private var whatIfCard: some View {
        VStack(spacing: 12) {
            Text("What-if")
                .font(FINDRFont.bold(10))
                .foregroundStyle(FINDRColor.brand)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(FINDRColor.surface, in: Capsule())
            Text("포트폴리오를 만든다면?")
                .font(FINDRFont.bold(16))
                .kerning(-0.32)
                .foregroundStyle(FINDRColor.primaryText)
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("현재").font(FINDRFont.regular(11)).foregroundStyle(FINDRColor.secondaryText)
                    Text("29개").font(FINDRFont.bold(28)).foregroundStyle(FINDRColor.primaryText)
                }
                FINDRIcon(name: FINDRAssetName.pathArrow, size: 18, tint: FINDRColor.inactiveIcon)
                VStack(spacing: 2) {
                    Text("완료 후").font(FINDRFont.regular(11)).foregroundStyle(FINDRColor.brand)
                    Text("41개").font(FINDRFont.bold(28)).foregroundStyle(FINDRColor.brand)
                }
            }
            Text("+12개의 새로운 기회")
                .font(FINDRFont.bold(12))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(FINDRColor.brandButton, in: Capsule())
            HStack(spacing: 6) {
                breakdown("교육", "+4")
                breakdown("공모전", "+3")
                breakdown("인턴", "+3")
                breakdown("지원", "+2")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func breakdown(_ category: String, _ count: String) -> some View {
        HStack(spacing: 3) {
            Text(category).foregroundStyle(FINDRColor.secondaryText)
            Text(count).font(FINDRFont.bold(11)).foregroundStyle(FINDRColor.brand)
        }
        .font(FINDRFont.regular(11))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var categoryTabs: some View {
        HStack(spacing: 18) {
            ForEach(categories, id: \.self) { category in
                Button { selectedCategory = category } label: {
                    VStack(spacing: 8) {
                        Text(category)
                            .font(selectedCategory == category ? FINDRFont.bold(13) : FINDRFont.regular(13))
                            .foregroundStyle(selectedCategory == category ? FINDRColor.primaryText : FINDRColor.secondaryText)
                        Rectangle()
                            .fill(selectedCategory == category ? FINDRColor.primaryText : .clear)
                            .frame(height: 2)
                    }
                }
                .buttonStyle(.plain)
            }
            Spacer(minLength: 0)
        }
        .overlay(alignment: .bottom) { FINDRColor.divider.frame(height: 1).offset(y: 1) }
    }

    private func actionCard(_ item: (String, String, String, Color), index: Int) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(item.3).frame(width: 44, height: 44)
                FINDRIcon(name: item.2, size: 20, tint: index == 0 ? FINDRColor.brand : (index == 1 ? FINDRColor.successStatus : (index == 2 ? FINDRColor.warningStatus : FINDRColor.brand)))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.0)
                    .font(FINDRFont.bold(14))
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(1)
                Text(item.1)
                    .font(FINDRFont.regular(11))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 0) {
                Text(["+12개", "+8개", "+5개", "+4개"][index])
                    .font(FINDRFont.bold(14))
                    .foregroundStyle(FINDRColor.brand)
                Text("기회")
                    .font(FINDRFont.regular(10))
                    .foregroundStyle(FINDRColor.tertiaryText)
            }
        }
        .padding(14)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(FINDRColor.border, lineWidth: 1)
        }
    }
}
