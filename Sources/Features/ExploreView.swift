import SwiftUI

struct ExploreView: View {
    let onOpenOpportunity: (Opportunity) -> Void

    @State private var query = ""
    @State private var selectedCategory = "전체"
    @State private var sortByRecommended = true
    @State private var selectedFilters: [String: String] = [:]

    private let firstCategoryRow = ["전체", "교육", "공모전", "대외활동"]
    private let secondCategoryRow = ["장학금", "창업", "인턴", "지원사업", "행사"]
    private let opportunities = Opportunity.samples

    private var filteredOpportunities: [Opportunity] {
        let matchingQuery = opportunities.filter {
            query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) || $0.organization.localizedCaseInsensitiveContains(query)
        }
        guard selectedCategory != "전체" else { return matchingQuery }
        return matchingQuery.filter { $0.categories.contains(selectedCategory) }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                header
                searchField
                categoryFilters
                detailFilters
                HStack {
                    Text("총 \(selectedCategory == "전체" && query.isEmpty ? "312" : "\(filteredOpportunities.count)")개의 기회")
                        .font(FINDRFont.regular(12))
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
                LazyVStack(spacing: 0) {
                    ForEach(filteredOpportunities) { opportunity in
                        OpportunityListRow(opportunity: opportunity) {
                            onOpenOpportunity(opportunity)
                        }
                    }
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 14)
        }
        .background(FINDRColor.canvas)
    }

    private var header: some View {
        HStack {
            Text("기회 탐색")
                .font(FINDRFont.title)
                .kerning(-0.44)
                .foregroundStyle(FINDRColor.primaryText)
            Spacer()
            Button {} label: {
                FINDRIcon(name: FINDRAssetName.bell, size: 22, tint: FINDRColor.primaryText)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("알림")
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            FINDRIcon(name: FINDRAssetName.search, size: 17, tint: FINDRColor.inactiveIcon)
            TextField("공고명, 기관명, 분야로 검색해보세요", text: $query)
                .font(FINDRFont.regular(13))
                .foregroundStyle(FINDRColor.primaryText)
                .tint(FINDRColor.brand)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
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
            filterMenu(title: selectedFilters["지역"] ?? "지역", options: ["전체 지역", "광주", "서울", "온라인"])
            filterMenu(title: selectedFilters["대상"] ?? "대상", options: ["전체 대상", "중학생", "고등학생", "대학생"])
            filterMenu(title: selectedFilters["마감일"] ?? "마감일", options: ["전체", "7일 이내", "30일 이내"])
            filterMenu(title: selectedFilters["방식"] ?? "온/오프라인", options: ["전체", "온라인", "오프라인"])
        }
    }

    private func filterMenu(title: String, options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) { selectedFilters[title] = option }
            }
        } label: {
            HStack(spacing: 3) {
                Text(title)
                    .font(FINDRFont.regular(11))
                FINDRIcon(name: FINDRAssetName.chevronDown, size: 12, tint: FINDRColor.secondaryText)
            }
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.horizontal, 9)
            .frame(height: 32)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(FINDRColor.borderStrong, lineWidth: 1))
        }
        .menuStyle(.borderlessButton)
    }
}
