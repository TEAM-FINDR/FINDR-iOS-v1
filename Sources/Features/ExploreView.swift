import SwiftUI

struct ExploreView: View {
    @Binding var query: String
    @Binding var filterResetVersion: Int
    @Binding var selectedFilters: [String: String]
    @Binding var selectedSort: FINDRExploreSort
    let onOpenOpportunity: (Opportunity) -> Void
    let onOpenNotifications: () -> Void
    let onOpenSearch: () -> Void
    let onOpenFilters: () -> Void
    let onOpenSort: () -> Void

    @State private var selectedCategory = "전체"

    private let firstCategoryRow = ["전체", "교육", "공모전", "대외활동"]
    private let secondCategoryRow = ["장학금", "창업", "인턴", "지원사업", "행사"]
    private let opportunities = Opportunity.samples

    private var filteredOpportunities: [Opportunity] {
        let matches = opportunities
            .filter { opportunity in
                query.isEmpty || opportunity.title.localizedCaseInsensitiveContains(query) || opportunity.organization.localizedCaseInsensitiveContains(query)
            }
            .filter { opportunity in
                selectedCategory == "전체" || opportunity.categories.contains(selectedCategory)
            }
            .filter { opportunity in
                guard let region = selectedFilters["지역"], region != "전체 지역" else { return true }
                return opportunity.location == region
            }
            .filter { opportunity in
                guard let target = selectedFilters["대상"], target != "전체 대상" else { return true }
                return matchesTarget(target, opportunity: opportunity)
            }
            .filter { opportunity in
                guard let deadline = selectedFilters["마감일"], deadline != "전체" else { return true }
                let daysRemaining = deadlineDays(for: opportunity)
                return deadline == "7일 이내" ? daysRemaining <= 7 : daysRemaining <= 30
            }
            .filter { opportunity in
                guard let mode = selectedFilters["방식"], mode != "전체" else { return true }
                return mode == "온라인" ? opportunity.location == "온라인" : opportunity.location != "온라인"
            }
        return selectedSort.sorted(matches)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                header
                searchField
                categoryFilters
                detailFilters
                HStack {
                    Text("총 \(FINDRExploreFilterLogic.resultCount(opportunities: opportunities, query: query, category: selectedCategory, selections: selectedFilters))개의 기회")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                    Spacer()
                    Button {
                        onOpenSort()
                    } label: {
                        HStack(spacing: 4) {
                            FINDRIcon(name: FINDRAssetName.sliders, size: 14, tint: FINDRColor.secondaryText)
                            Text(selectedSort.title)
                                .font(FINDRFont.medium(11))
                                .foregroundStyle(FINDRColor.secondaryText)
                        }
                    }
                    .buttonStyle(.plain)
                }
                if filteredOpportunities.isEmpty {
                    Text("조건에 맞는 기회가 없어요")
                        .font(FINDRFont.regular(13))
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 48)
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredOpportunities) { opportunity in
                            OpportunityListRow(opportunity: opportunity, showsProgress: false, onTap: {
                                onOpenOpportunity(opportunity)
                            })
                        }
                    }
                    .padding(.top, 1)
                    .padding(.bottom, 12)
                }
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 30)
        }
        .background(FINDRColor.surface)
        .onChange(of: filterResetVersion) { _, _ in
            selectedCategory = "전체"
            selectedSort = .recommended
            selectedFilters = [:]
        }
    }

    private var header: some View {
        FINDRPageHeader(
            title: "기회 탐색",
            trailingIcon: FINDRAssetName.bell,
            trailingLabel: "알림",
            action: onOpenNotifications,
            titleKerning: -0.44,
            trailingSize: 24,
            trailingTint: FINDRColor.primaryText
        )
    }

    private var searchField: some View {
        Button(action: onOpenSearch) {
            FINDRSearchField(text: $query, placeholder: "공고명, 기관명, 분야로 검색해보세요")
                .allowsHitTesting(false)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("검색")
        .accessibilityValue(query.isEmpty ? "공고명, 기관명, 분야로 검색해보세요" : query)
    }

    private var categoryFilters: some View {
        VStack(alignment: .leading, spacing: 8) {
            categoryRow(firstCategoryRow)
            categoryRow(secondCategoryRow)
        }
    }

    private func categoryRow(_ categories: [String]) -> some View {
        HStack(spacing: 8) {
            ForEach(categories, id: \.self) { category in
                FINDRPill(title: category, isSelected: selectedCategory == category) {
                    selectedCategory = category
                }
            }
        }
    }

    private var detailFilters: some View {
        HStack(spacing: 6) {
            filterTrigger(key: "지역", title: "지역", width: 59)
            filterTrigger(key: "대상", title: "대상", width: 59)
            filterTrigger(key: "마감일", title: "마감일", width: 70)
            filterTrigger(key: "방식", title: "온/오프라인", width: 96)
        }
    }

    private func filterTrigger(key: String, title: String, width: CGFloat) -> some View {
        FINDRFilterMenu(
            title: title,
            selectedOption: selectedFilters[key],
            action: onOpenFilters,
            width: width
        )
    }

    private func matchesTarget(_ target: String, opportunity: Opportunity) -> Bool {
        switch target {
        case "중학생":
            opportunity.categories.contains("청소년") || opportunity.conditionNames.contains { $0.contains("중·고등학생") }
        case "고등학생":
            opportunity.categories.contains("청소년") || opportunity.conditionNames.contains { $0.contains("고등학생") || $0.contains("고등·대학생") }
        case "대학생":
            opportunity.conditionNames.contains { $0.contains("대학생") }
        case "청년":
            opportunity.categories.contains { $0.contains("청년") } || opportunity.conditionNames.contains { $0.contains("청년") }
        default:
            true
        }
    }

    private func deadlineDays(for opportunity: Opportunity) -> Int {
        Int(opportunity.deadline.dropFirst(2)) ?? Int.max
    }
}
