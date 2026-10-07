import SwiftUI

struct HomeView: View {
    let onOpenOpportunity: (Opportunity) -> Void
    let onSeeAll: () -> Void
    let onOpenNotifications: () -> Void
    let onOpenAPath: () -> Void

    @State private var selectedFilter = "지금 가능 4"
    private let opportunities = Opportunity.samples
    private let filters = ["지금 가능 4", "거의 가능 7", "마감 임박 5"]

    private var featuredOpportunity: Opportunity {
        let matches: [Opportunity]
        switch selectedFilter {
        case "거의 가능 7":
            matches = opportunities.filter { $0.status == .nearlyEligible }
        case "마감 임박 5":
            matches = opportunities.filter { (Int($0.deadline.dropFirst(2)) ?? 99) <= 7 }
        default:
            matches = opportunities.filter { $0.status == .eligible }
        }
        return matches.first ?? opportunities[0]
    }

    private var featuredCategoryLabels: [String] {
        featuredOpportunity.id == "gwangju-ai-camp" ? ["교육", "광주", "청소년"] : featuredOpportunity.categories
    }

    private var isNearlyEligibleSelected: Bool {
        selectedFilter == "거의 가능 7"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: isNearlyEligibleSelected ? 16 : 18) {
                header
                    .frame(height: 108, alignment: .top)
                filterSegment

                if isNearlyEligibleSelected {
                    nearlyEligibleList
                } else {
                    defaultHomeContent
                }
            }
            .padding(.top, isNearlyEligibleSelected ? 14 : 24)
        }
        .background(FINDRColor.canvas)
    }

    private var filterSegment: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    FINDRPill(title: filter, isSelected: selectedFilter == filter) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, FINDRSpacing.screen)
        }
        .contentMargins(.zero)
        .frame(height: 34)
    }

    private var nearlyEligibleList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("조건 1개만 채우면 지원할 수 있어요")
                .font(FINDRFont.regular(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.secondaryText)

            VStack(spacing: 12) {
                ForEach(Opportunity.homeNearlyEligibleSamples) { opportunity in
                    HomeNearlyEligibleOpportunityCard(
                        opportunity: opportunity,
                        onOpenOpportunity: { onOpenOpportunity(opportunity) },
                        onPrepare: onOpenAPath
                    )
                }
            }
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 7)
    }

    private var defaultHomeContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            FeaturedOpportunityCard(opportunity: featuredOpportunity, categoryLabels: featuredCategoryLabels) {
                onOpenOpportunity(featuredOpportunity)
            }
            .padding(.horizontal, FINDRSpacing.screen)

            VStack(alignment: .leading, spacing: 24) {
                FINDRSectionHeader(
                    title: "오늘의 추천",
                    actionTitle: "전체보기",
                    actionIconName: FINDRAssetName.chevronRight,
                    action: onSeeAll
                )
                    .frame(height: 24)
                    .padding(.horizontal, FINDRSpacing.screen)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CompactOpportunityCard(opportunity: opportunities[1]) { onOpenOpportunity(opportunities[1]) }
                        CompactOpportunityCard(opportunity: opportunities[2]) { onOpenOpportunity(opportunities[2]) }
                        CompactOpportunityCard(opportunity: opportunities[3]) { onOpenOpportunity(opportunities[3]) }
                    }
                }
                .contentMargins(.zero)
                .frame(height: 130)
                .padding(.horizontal, FINDRSpacing.screen)
            }

            VStack(alignment: .leading, spacing: 24) {
                Text("조금만 더 하면 열려요")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(height: 24, alignment: .leading)
                    .padding(.horizontal, FINDRSpacing.screen)

                Button(action: onSeeAll) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(FINDRColor.successSubtle).frame(width: 44, height: 44)
                            FINDRIcon(name: FINDRAssetName.folder, size: 20, tint: FINDRColor.successStatus)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("포트폴리오 만들기")
                                .font(FINDRFont.bold(15))
                                .kerning(-0.3)
                                .foregroundStyle(FINDRColor.primaryText)
                            HStack(spacing: 2) {
                                Text("+12개")
                                    .font(FINDRFont.bold(13))
                                    .foregroundStyle(FINDRColor.brand)
                                Text("의 새로운 기회")
                                    .font(FINDRFont.regular(13))
                                    .foregroundStyle(FINDRColor.secondaryText)
                            }
                            .kerning(-0.26)
                        }
                        Spacer()
                        FINDRIcon(name: FINDRAssetName.arrowRight, size: 20, tint: FINDRColor.primaryText)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 78)
                    .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(FINDRColor.border, lineWidth: 1)
                    }
                    .shadow(color: FINDRShadow.card, radius: 18, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, FINDRSpacing.screen)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: isNearlyEligibleSelected ? 9 : 8) {
                Text("안녕하세요,\n시우님")
                    .font(FINDRFont.titleLarge)
                    .kerning(-0.52)
                    .lineLimit(2, reservesSpace: true)
                    .lineSpacing(-4)
                    .foregroundStyle(FINDRColor.heading)
                    .frame(height: 68, alignment: .topLeading)
                    .offset(y: isNearlyEligibleSelected ? 1 : 0)
                HStack(spacing: 5) {
                    FINDRIcon(name: FINDRAssetName.unlock, size: 14, tint: FINDRColor.brand)
                    Text("오늘 새로 열린 기회 4개")
                        .font(FINDRFont.medium(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.brand)
                        .frame(height: 18, alignment: .leading)
                }
            }
            Spacer()
            FINDRIconButton(
                iconName: FINDRAssetName.bell,
                accessibilityLabel: "알림",
                action: onOpenNotifications,
                size: 24,
                tint: FINDRColor.primaryText
            )
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, isNearlyEligibleSelected ? 12 : 10)
        .padding(.bottom, 4)
    }
}
