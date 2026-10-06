import SwiftUI

struct HomeView: View {
    let onOpenOpportunity: (Opportunity) -> Void
    let onSeeAll: () -> Void
    let onOpenNotifications: () -> Void

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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                header
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
                FeaturedOpportunityCard(opportunity: featuredOpportunity) {
                    onOpenOpportunity(featuredOpportunity)
                }
                .padding(.horizontal, FINDRSpacing.screen)

                VStack(alignment: .leading, spacing: 12) {
                    FINDRSectionHeader(title: "오늘의 추천", actionTitle: "전체보기  ›", action: onSeeAll)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CompactOpportunityCard(opportunity: opportunities[1]) { onOpenOpportunity(opportunities[1]) }
                            CompactOpportunityCard(opportunity: opportunities[2]) { onOpenOpportunity(opportunities[2]) }
                            CompactOpportunityCard(opportunity: opportunities[3]) { onOpenOpportunity(opportunities[3]) }
                        }
                        .padding(.horizontal, FINDRSpacing.screen)
                    }
                    .contentMargins(.zero)
                }
                .padding(.leading, FINDRSpacing.screen)

                VStack(alignment: .leading, spacing: 12) {
                    Text("조금만 더 하면 열려요")
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                    Button(action: onSeeAll) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(FINDRColor.successSubtle).frame(width: 44, height: 44)
                                FINDRIcon(name: FINDRAssetName.folder, size: 20, tint: FINDRColor.successStatus)
                            }
                            VStack(alignment: .leading, spacing: 1) {
                                Text("포트폴리오 만들기")
                                    .font(FINDRFont.bold(14))
                                    .foregroundStyle(FINDRColor.primaryText)
                                (Text("+12개").foregroundColor(FINDRColor.brand) + Text("의 새로운 기회").foregroundColor(FINDRColor.secondaryText))
                                    .font(FINDRFont.medium(12))
                            }
                            Spacer()
                            FINDRIcon(name: FINDRAssetName.arrowRight, size: 20, tint: FINDRColor.primaryText)
                        }
                        .padding(16)
                        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(FINDRColor.border, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.bottom, 12)
            }
            .padding(.top, 8)
        }
        .background(FINDRColor.canvas)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 7) {
                Text("안녕하세요,\n시우님")
                    .font(FINDRFont.titleLarge)
                    .kerning(-0.52)
                    .lineSpacing(0)
                    .foregroundStyle(FINDRColor.primaryText)
                HStack(spacing: 5) {
                    FINDRIcon(name: FINDRAssetName.unlock, size: 14, tint: FINDRColor.brand)
                    Text("오늘 새로 열린 기회 4개")
                        .font(FINDRFont.medium(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.brand)
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
            .padding(.top, 2)
        }
        .padding(.horizontal, FINDRSpacing.screen)
    }
}
