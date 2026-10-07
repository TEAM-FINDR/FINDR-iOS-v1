import SwiftUI

struct SearchView: View {
    @AppStorage("FINDR.search.recentTerms") private var recentSearchStorage = "AI 캠프|해커톤|장학금|디자인 공모전"
    @Binding var query: String
    @Environment(\.dismiss) private var dismiss

    let onSubmit: () -> Void

    private let popularSearches = [
        "AI 교육",
        "청소년 창업",
        "코딩 대회",
        "해외 봉사",
        "국가 장학금",
        "디자인 공모전",
        "인턴십",
        "메이커 캠프"
    ]

    private var recentSearches: [String] {
        recentSearchStorage
            .split(separator: "|")
            .map(String.init)
    }

    var body: some View {
        VStack(spacing: 0) {
            searchHeader

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if !recentSearches.isEmpty {
                        recentHeader
                            .padding(.bottom, 18)
                        recentSearchChips
                            .padding(.bottom, 18)
                    }

                    Text("인기 검색어")
                        .font(FINDRFont.bodyLargeBold)
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .padding(.bottom, 19)

                    popularSearchList
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.medium)
                .padding(.bottom, FINDRSpacing.large)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.surface)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var searchHeader: some View {
        HStack(spacing: FINDRSpacing.medium) {
            HStack(spacing: FINDRSpacing.small) {
                FINDRIcon(
                    name: FINDRAssetName.search,
                    size: 18,
                    tint: FINDRColor.inactiveIcon,
                    usesTemplate: false
                )

                TextField(
                    "공고명, 기관명, 분야로 검색해보세요",
                    text: $query,
                    prompt: Text("공고명, 기관명, 분야로 검색해보세요")
                        .foregroundColor(FINDRColor.tertiaryText)
                )
                .font(FINDRFont.regular(14))
                .kerning(-0.28)
                .foregroundStyle(FINDRColor.primaryText)
                .tint(FINDRColor.brand)
                .submitLabel(.search)
                .onSubmit { submitSearch() }
            }
            .padding(.horizontal, FINDRSpacing.large)
            .padding(.vertical, FINDRSpacing.medium)
            .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                    .stroke(Color(red: 47.0 / 255, green: 107.0 / 255, blue: 1), lineWidth: 1.5)
            }

            Button("취소", action: dismiss.callAsFunction)
                .font(FINDRFont.medium(14))
                .kerning(-0.28)
                .foregroundStyle(FINDRColor.secondaryText)
                .buttonStyle(.plain)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 15)
        .padding(.bottom, FINDRSpacing.small)
    }

    private var recentHeader: some View {
        HStack {
            Text("최근 검색")
                .font(FINDRFont.bodyLargeBold)
                .kerning(-0.3)
                .foregroundStyle(FINDRColor.primaryText)

            Spacer()

            Button("전체 삭제", action: clearRecentSearches)
                .font(FINDRFont.caption)
                .kerning(-0.24)
                .foregroundStyle(FINDRColor.tertiaryText)
                .buttonStyle(.plain)
        }
    }

    private var recentSearchChips: some View {
        FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: 6) {
            ForEach(recentSearches, id: \.self) { term in
                recentSearchChip(term)
            }
        }
    }

    private func recentSearchChip(_ term: String) -> some View {
        HStack(spacing: FINDRSpacing.xSmall) {
            Button {
                submitSearch(term)
            } label: {
                Text(term)
                    .font(FINDRFont.bodySmall)
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
            }
            .buttonStyle(.plain)

            Button {
                removeRecentSearch(term)
            } label: {
                FINDRIcon(
                    name: FINDRAssetName.recentSearchRemove,
                    size: 12,
                    tint: FINDRColor.inactiveIcon,
                    usesTemplate: false
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(term) 최근 검색 삭제")
        }
        .padding(.leading, FINDRSpacing.large)
        .padding(.trailing, FINDRSpacing.medium)
        .padding(.vertical, FINDRSpacing.small)
        .background(FINDRColor.subtle, in: Capsule())
    }

    private var popularSearchList: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            ForEach(Array(popularSearches.enumerated()), id: \.offset) { index, term in
                Button {
                    submitSearch(term)
                } label: {
                    HStack(spacing: FINDRSpacing.medium) {
                        Text("\(index + 1)")
                            .font(FINDRFont.bold(14))
                            .foregroundStyle(index < 3 ? FINDRColor.brand : FINDRColor.tertiaryText)

                        Text(term)
                            .font(FINDRFont.body)
                            .kerning(-0.28)
                            .foregroundStyle(FINDRColor.primaryText)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func submitSearch(_ term: String? = nil) {
        let value = (term ?? query).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }

        query = value
        let updatedSearches = [value] + recentSearches.filter { $0 != value }
        recentSearchStorage = updatedSearches.prefix(8).joined(separator: "|")
        onSubmit()
    }

    private func removeRecentSearch(_ term: String) {
        recentSearchStorage = recentSearches.filter { $0 != term }.joined(separator: "|")
    }

    private func clearRecentSearches() {
        recentSearchStorage = ""
    }
}
