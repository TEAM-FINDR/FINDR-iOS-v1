import SwiftUI

struct APathView: View {
    @State private var selectedCategory = "추천 행동"
    @State private var showHelp = false

    private let categories = ["추천 행동", "자격증", "교육", "경험"]
    private let actions = [
        PathAction(
            title: "포트폴리오 만들기", subtitle: "IT·개발 분야 기회가 열려요",
            icon: FINDRAssetName.file, category: "경험",
            background: FINDRColor.brandSubtle, tint: FINDRColor.brand, opportunityCount: 12
        ),
        PathAction(
            title: "컴퓨터활용능력 2급 취득", subtitle: "공공기관·대외활동 기회가 열려요",
            icon: FINDRAssetName.monitor, category: "자격증",
            background: FINDRColor.successSubtle, tint: FINDRColor.successStatus, opportunityCount: 8
        ),
        PathAction(
            title: "AI 관련 교육 수료", subtitle: "교육·해커톤 기회가 열려요",
            icon: FINDRAssetName.cpu, category: "교육",
            background: FINDRColor.warningSubtle, tint: FINDRColor.warningStatus, opportunityCount: 5
        ),
        PathAction(
            title: "프로젝트 경험 쌓기", subtitle: "공모전 기회가 열려요",
            icon: FINDRAssetName.rocket, category: "경험",
            background: FINDRColor.accentSubtle, tint: FINDRColor.brand, opportunityCount: 4
        )
    ]

    private var visibleActions: [PathAction] {
        guard selectedCategory != "추천 행동" else { return actions }
        return actions.filter { $0.category == selectedCategory }
    }

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
                    ForEach(visibleActions) { action in
                        actionCard(action)
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
        FINDRPageHeader(
            title: "A-Path",
            trailingIcon: FINDRAssetName.help,
            trailingLabel: "A-Path 도움말",
            action: { showHelp = true },
            trailingSize: 21
        )
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
        FINDRUnderlineTabs(
            titles: categories,
            selection: $selectedCategory,
            fontSize: 13,
            itemSpacing: 18,
            indicatorSpacing: 8,
            equalWidth: false,
            unselectedTextColor: FINDRColor.secondaryText,
            unselectedIndicatorColor: .clear,
            showsBottomDivider: true
        )
    }

    private func actionCard(_ item: PathAction) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(item.background).frame(width: 44, height: 44)
                FINDRIcon(name: item.icon, size: 20, tint: item.tint)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(FINDRFont.bold(14))
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(1)
                Text(item.subtitle)
                    .font(FINDRFont.regular(11))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 0) {
                Text("+\(item.opportunityCount)개")
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

private struct PathAction: Identifiable {
    let title: String
    let subtitle: String
    let icon: String
    let category: String
    let background: Color
    let tint: Color
    let opportunityCount: Int

    var id: String { title }
}
