import SwiftUI

struct SavedView: View {
    @Binding var savedIDs: Set<String>
    let onOpenOpportunity: (Opportunity) -> Void
    let onOpenNotifications: () -> Void

    @State private var selectedFilter = "전체"
    @State private var remindersEnabled = true
    @State private var sortByDeadline = true

    private let filters = ["전체", "지원 가능", "마감 임박"]

    private var savedOpportunities: [Opportunity] {
        let items = Opportunity.samples.filter { savedIDs.contains($0.id) }
        let filtered: [Opportunity]
        switch selectedFilter {
        case "지원 가능": filtered = items.filter { $0.status == .eligible }
        case "마감 임박": filtered = items.filter { Int($0.deadline.dropFirst(2)) ?? 99 <= 7 }
        default: filtered = items
        }
        return sortByDeadline ? filtered.sorted { (Int($0.deadline.dropFirst(2)) ?? 99) < (Int($1.deadline.dropFirst(2)) ?? 99) } : filtered
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                filterBar
                HStack {
                    Menu {
                        Button("마감 임박순") { sortByDeadline = true }
                        Button("추천순") { sortByDeadline = false }
                    } label: {
                        HStack(spacing: 2) {
                            Text(sortByDeadline ? "마감 임박순" : "추천순")
                                .font(FINDRFont.medium(13))
                                .kerning(-0.26)
                            FINDRIcon(name: FINDRAssetName.chevronDown, size: 14, tint: FINDRColor.secondaryText)
                        }
                        .foregroundStyle(FINDRColor.secondaryText)
                    }
                    Spacer()
                    Button { remindersEnabled.toggle() } label: {
                        HStack(spacing: 4) {
                            FINDRIcon(name: FINDRAssetName.bell, size: 14, tint: FINDRColor.brand)
                            Text(remindersEnabled ? "마감 알림 켜짐" : "마감 알림 꺼짐")
                                .font(FINDRFont.medium(12))
                                .foregroundStyle(FINDRColor.brand)
                        }
                    }
                    .buttonStyle(.plain)
                }
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(savedOpportunities) { opportunity in
                            OpportunityListRow(opportunity: opportunity, asCard: true, showsLocation: false, onTap: {
                                onOpenOpportunity(opportunity)
                            })
                        }
                    }
                }
                .frame(height: 422)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 30)
        }
        .background(FINDRColor.canvas)
    }

    private var header: some View {
        FINDRPageHeader(
            title: "저장한 기회",
            trailingIcon: FINDRAssetName.bell,
            trailingLabel: "알림",
            action: onOpenNotifications,
            titleKerning: -0.44
        )
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            ForEach(filters, id: \.self) { filter in
                let count: Int = switch filter {
                case "전체": savedIDs.count
                case "지원 가능": Opportunity.samples.filter { savedIDs.contains($0.id) && $0.status == .eligible }.count
                default: Opportunity.samples.filter { savedIDs.contains($0.id) && (Int($0.deadline.dropFirst(2)) ?? 99) <= 7 }.count
                }
                FINDRPill(title: "\(filter) \(count)", isSelected: selectedFilter == filter) {
                    selectedFilter = filter
                }
            }
        }
    }
}
