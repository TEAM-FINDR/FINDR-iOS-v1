import SwiftUI

enum FINDRExploreSort: String, CaseIterable, Identifiable {
    case recommended
    case deadline
    case latest
    case eligibility

    var id: String { rawValue }

    var title: String {
        switch self {
        case .recommended: "추천순"
        case .deadline: "마감 임박순"
        case .latest: "최신순"
        case .eligibility: "조건 충족순"
        }
    }

    func sorted(_ opportunities: [Opportunity]) -> [Opportunity] {
        let indexed = Array(opportunities.enumerated())
        switch self {
        case .recommended:
            return opportunities
        case .deadline:
            return indexed.sorted(by: { left, right in
                let leftDays = deadlineDays(for: left.element)
                let rightDays = deadlineDays(for: right.element)
                return leftDays == rightDays ? left.offset < right.offset : leftDays < rightDays
            }).map(\.element)
        case .latest:
            // The local fixture has no publishedAt field, so reverse its current order as a deterministic preview.
            return indexed.sorted { $0.offset > $1.offset }.map(\.element)
        case .eligibility:
            return indexed.sorted(by: { left, right in
                let leftRatio = left.element.progress
                let rightRatio = right.element.progress
                return leftRatio == rightRatio ? left.offset < right.offset : leftRatio > rightRatio
            }).map(\.element)
        }
    }

    private func deadlineDays(for opportunity: Opportunity) -> Int {
        Int(opportunity.deadline.dropFirst(2)) ?? Int.max
    }
}

struct FINDRExploreSortSheetOverlay: View {
    let selectedSort: FINDRExploreSort
    let onDismiss: () -> Void
    let onSelect: (FINDRExploreSort) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityLabel("정렬 창 닫기")
                    .accessibilityAddTraits(.isButton)

                sheet
                    .frame(width: geometry.size.width, height: geometry.size.width * 355 / 393)
                    .background(FINDRColor.surface)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 20,
                            topTrailingRadius: 20,
                            style: .continuous
                        )
                    )
                    .transition(.move(edge: .bottom))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }

    private var sheet: some View {
        VStack(spacing: 0) {
            sheetHeader

            VStack(spacing: 8) {
                ForEach(FINDRExploreSort.allCases) { option in
                    FINDRProfileStatusOptionRowView(
                        title: option.title,
                        isSelected: selectedSort == option
                    ) {
                        onSelect(option)
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityHint("정렬 기준으로 선택합니다")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)

            VStack(spacing: 0) {
                Capsule()
                    .fill(FINDRColor.primaryText)
                    .frame(width: 134, height: 5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(FINDRColor.surface)
    }

    private var sheetHeader: some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(FINDRColor.track)
                .frame(width: 36, height: 5)

            HStack(spacing: 0) {
                Text("정렬")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: onDismiss) {
                    FINDRIcon(name: FINDRAssetName.aPathClose, size: 22, tint: FINDRColor.secondaryText)
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }
            .frame(height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}
