import SwiftUI

struct SearchResultsView: View {
    @Binding var query: String
    @FocusState private var isSearchFocused: Bool

    let onOpenOpportunity: (Opportunity) -> Void
    let onCancel: () -> Void
    let onClear: () -> Void
    let onResetFilters: () -> Void

    private var results: [FINDRSearchResult] {
        FINDRSearchCatalog.results(for: query)
    }

    var body: some View {
        VStack(spacing: 0) {
            searchHeader

            if results.isEmpty {
                GeometryReader { geometry in
                    let topInset: CGFloat = 8
                    let bottomInset: CGFloat = 104

                    SearchEmptyState(query: query, onResetFilters: onResetFilters)
                        .frame(width: geometry.size.width - 2 * FINDRSpacing.screen)
                        .position(
                            x: geometry.size.width / 2,
                            y: topInset + (geometry.size.height - topInset - bottomInset) / 2
                        )
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("‘\(query)’ 검색 결과 \(FINDRSearchCatalog.resultCount(for: query, matching: results))개")
                            .font(FINDRFont.medium(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVStack(spacing: 16) {
                            ForEach(results) { result in
                                SearchResultRow(result: result) {
                                    onOpenOpportunity(result.opportunity)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, 6)
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

                TextField("", text: $query)
                    .focused($isSearchFocused)
                    .font(FINDRFont.regular(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(height: 20)
                    .submitLabel(.search)
                    .onSubmit { isSearchFocused = false }

                Button {
                    query = ""
                    isSearchFocused = false
                    onClear()
                } label: {
                    FINDRIcon(
                        name: FINDRAssetName.searchClear,
                        size: 16,
                        usesTemplate: false
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("검색어 지우기")
            }
            .padding(.horizontal, FINDRSpacing.large)
            .padding(.vertical, FINDRSpacing.medium)
            .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))

            Button("취소") {
                query = ""
                isSearchFocused = false
                onCancel()
            }
            .font(FINDRFont.medium(14))
            .kerning(-0.28)
            .foregroundStyle(FINDRColor.secondaryText)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 15)
        .padding(.bottom, FINDRSpacing.small)
    }
}

private struct SearchEmptyState: View {
    let query: String
    let onResetFilters: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(FINDRColor.subtle)
                .frame(width: 72, height: 72)
                .overlay {
                    FINDRIcon(name: FINDRAssetName.searchEmptyState, size: 32, usesTemplate: false)
                }

            Text("‘\(query)’ 결과가 없어요")
                .font(FINDRFont.bold(17))
                .kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText)
                .multilineTextAlignment(.center)

            Text("다른 키워드로 검색하거나 필터를 바꿔보세요.")
                .font(FINDRFont.regular(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.secondaryText)
                .multilineTextAlignment(.center)

            Button(action: onResetFilters) {
                Text("필터 초기화")
                    .font(FINDRFont.bold(15))
                    .kerning(-0.3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(FINDRColor.brand, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .frame(width: 180)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
    }
}

private struct SearchResultRow: View {
    let result: FINDRSearchResult
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: FINDRSpacing.medium) {
                SearchResultThumbnail(result: result)

                VStack(alignment: .leading, spacing: 2) {
                    Text(result.opportunity.title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)

                    Text("\(result.opportunity.organization) · \(result.opportunity.location)")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .lineLimit(1)

                    Text(result.opportunity.deadline)
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(result.opportunity.deadline == "D-3" ? FINDRColor.danger : FINDRColor.brand)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 20) {
                    FINDRIcon(name: FINDRAssetName.aPathMore, size: 18, tint: FINDRColor.inactiveIcon)
                    FINDRStatusBadge(status: result.opportunity.status)
                }
            }
            .padding(.vertical, FINDRSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct SearchResultThumbnail: View {
    let result: FINDRSearchResult

    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(LinearGradient(
                gradient: result.artwork.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .overlay {
                FINDRIcon(
                    name: result.iconName,
                    size: 24,
                    tint: result.usesDarkIcon ? FINDRColor.primaryText : .white,
                    usesTemplate: result.usesDarkIcon
                )
            }
            .frame(width: 64, height: 64)
            .accessibilityHidden(true)
    }
}
