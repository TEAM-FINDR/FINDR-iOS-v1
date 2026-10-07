import SwiftUI

struct SearchResultsView: View {
    @Binding var query: String
    @FocusState private var isSearchFocused: Bool

    let onOpenOpportunity: (Opportunity) -> Void
    let onCancel: () -> Void

    private var results: [FINDRSearchResult] {
        FINDRSearchCatalog.results(for: query)
    }

    var body: some View {
        VStack(spacing: 0) {
            searchHeader

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("‘\(query)’ 검색 결과 \(FINDRSearchCatalog.resultCount(for: query, matching: results))개")
                        .font(FINDRFont.medium(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if results.isEmpty {
                        Text("검색 결과가 없어요")
                            .font(FINDRFont.regular(14))
                            .foregroundStyle(FINDRColor.tertiaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                    } else {
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
                    isSearchFocused = true
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
