import SwiftUI

struct RecommendedOpportunitiesView: View {
    let onOpenOpportunity: (Opportunity) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory = "전체"

    private let categories = ["전체", "교육", "공모전", "대외활동", "창업"]

    private var filteredOpportunities: [Opportunity] {
        guard selectedCategory != "전체" else { return Opportunity.homeRecommendedSamples }
        return Opportunity.homeRecommendedSamples.filter { $0.categories.contains(selectedCategory) }
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationHeader
            categoryFilters

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("관심 분야 개발·디자인·창업 기준으로 골랐어요")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .frame(maxWidth: .infinity, minHeight: 17, alignment: .leading)

                    LazyVStack(spacing: 16) {
                        ForEach(filteredOpportunities) { opportunity in
                            OpportunityFeedRow(
                                opportunity: opportunity,
                                artworkOverride: artworkOverride(for: opportunity)
                            ) {
                                onOpenOpportunity(opportunity)
                            }
                        }
                    }
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.bottom, FINDRSpacing.large)
            }
        }
        .background(FINDRColor.surface)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var navigationHeader: some View {
        HStack(spacing: 0) {
            FINDRIconButton(
                iconName: FINDRAssetName.profileSetupBack,
                accessibilityLabel: "뒤로",
                action: { dismiss() },
                size: 24,
                tint: FINDRColor.primaryText
            )
            .frame(width: 64, height: 24, alignment: .leading)

            Text("오늘의 추천")
                .font(FINDRFont.bold(15))
                .kerning(-0.3)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(maxWidth: .infinity)

            Color.clear
                .frame(width: 64, height: 24)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.vertical, FINDRSpacing.small)
        .frame(height: 40)
    }

    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    FINDRPill(title: category, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.vertical, FINDRSpacing.small)
        }
        .contentMargins(.zero)
        .frame(height: 50)
    }

    private func artworkOverride(for opportunity: Opportunity) -> OpportunityArtwork? {
        opportunity.id == "gwangju-ai-camp" ? .homeDeadlineCPU : nil
    }
}
