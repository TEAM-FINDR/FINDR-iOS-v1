import SwiftUI

struct ExploreView: View {
    let onOpenOpportunity: (Opportunity) -> Void
    let onOpenNotifications: () -> Void

    @State private var query = ""
    @State private var selectedCategory = "전체"
    @State private var sortByRecommended = true
    @State private var selectedFilters: [String: String] = [:]

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
        guard !sortByRecommended else { return matches }
        return matches.sorted { deadlineDays(for: $0) < deadlineDays(for: $1) }
    }

    private var hasActiveFilters: Bool {
        !query.isEmpty || selectedCategory != "전체" || selectedFilters.values.contains { value in
            !["전체", "전체 지역", "전체 대상"].contains(value)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                header
                searchField
                categoryFilters
                detailFilters
                HStack {
                    Text("총 \(hasActiveFilters ? "\(filteredOpportunities.count)" : "312")개의 기회")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                    Spacer()
                    Button {
                        sortByRecommended.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            FINDRIcon(name: FINDRAssetName.sliders, size: 14, tint: FINDRColor.secondaryText)
                            Text(sortByRecommended ? "추천순" : "마감순")
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
            .padding(.top, 14)
        }
        .background(FINDRColor.surface)
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
        FINDRSearchField(text: $query, placeholder: "공고명, 기관명, 분야로 검색해보세요")
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
            filterMenu(key: "지역", title: "지역", options: ["전체 지역", "광주", "서울", "온라인"], width: 59)
            filterMenu(key: "대상", title: "대상", options: ["전체 대상", "중학생", "고등학생", "대학생"], width: 59)
            filterMenu(key: "마감일", title: "마감일", options: ["전체", "7일 이내", "30일 이내"], width: 70)
            filterMenu(key: "방식", title: "온/오프라인", options: ["전체", "온라인", "오프라인"], width: 96)
        }
    }

    private func filterMenu(key: String, title: String, options: [String], width: CGFloat) -> some View {
        FINDRFilterMenu(
            title: title,
            selectedOption: selectedFilters[key],
            resetOption: options[0],
            options: options,
            onSelect: { option in
                if option == options[0] {
                    selectedFilters.removeValue(forKey: key)
                } else {
                    selectedFilters[key] = option
                }
            },
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
        default:
            true
        }
    }

    private func deadlineDays(for opportunity: Opportunity) -> Int {
        Int(opportunity.deadline.dropFirst(2)) ?? Int.max
    }
}
