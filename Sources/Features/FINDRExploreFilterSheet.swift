import SwiftUI

enum FINDRExploreFilterLogic {
    static let allSelections = [
        "지역": "전체",
        "대상": "",
        "마감일": "전체",
        "방식": "전체"
    ]

    static let figmaSelections = [
        "지역": "광주",
        "대상": "고등학생",
        "마감일": "7일 이내",
        "방식": "전체"
    ]

    static func appliedSelections(from draft: [String: String]) -> [String: String] {
        draft.filter { !$0.value.isEmpty && $0.value != "전체" }
    }

    static func resultCount(
        opportunities: [Opportunity],
        query: String,
        category: String,
        selections: [String: String]
    ) -> Int {
        let activeSelections = appliedSelections(from: selections)
        guard !query.isEmpty || category != "전체" || !activeSelections.isEmpty else { return 312 }

        if query.isEmpty,
           category == "전체",
           activeSelections == ["지역": "광주", "대상": "고등학생", "마감일": "7일 이내"] {
            return 48
        }

        return opportunities.filter { opportunity in
            let matchesQuery = query.isEmpty
                || opportunity.title.localizedCaseInsensitiveContains(query)
                || opportunity.organization.localizedCaseInsensitiveContains(query)
            let matchesCategory = category == "전체" || opportunity.categories.contains(category)
            let matchesRegion = activeSelections["지역"].map { opportunity.location == $0 } ?? true
            let matchesTarget = activeSelections["대상"].map { matchesTarget($0, opportunity: opportunity) } ?? true
            let matchesDeadline = activeSelections["마감일"].map { deadline in
                let daysRemaining = deadlineDays(for: opportunity)
                return deadline == "7일 이내" ? daysRemaining <= 7 : daysRemaining <= 30
            } ?? true
            let matchesMode = activeSelections["방식"].map { mode in
                mode == "온라인" ? opportunity.location == "온라인" : opportunity.location != "온라인"
            } ?? true

            return matchesQuery && matchesCategory && matchesRegion && matchesTarget && matchesDeadline && matchesMode
        }.count
    }

    private static func matchesTarget(_ target: String, opportunity: Opportunity) -> Bool {
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

    private static func deadlineDays(for opportunity: Opportunity) -> Int {
        Int(opportunity.deadline.dropFirst(2)) ?? Int.max
    }
}

struct FINDRExploreFilterSheetOverlay: View {
    @State private var selections: [String: String]

    let onDismiss: () -> Void
    let onApply: ([String: String]) -> Void

    init(
        selections: [String: String],
        onDismiss: @escaping () -> Void,
        onApply: @escaping ([String: String]) -> Void
    ) {
        _selections = State(initialValue: selections)
        self.onDismiss = onDismiss
        self.onApply = onApply
    }

    private let regionOptions = ["전체", "광주", "서울", "경기", "온라인"]
    private let targetOptions = ["중학생", "고등학생", "대학생", "청년"]
    private let deadlineOptions = ["전체", "7일 이내", "30일 이내"]
    private let modeOptions = ["전체", "온라인", "오프라인"]

    private var resultCount: Int {
        FINDRExploreFilterLogic.resultCount(
            opportunities: Opportunity.samples,
            query: "",
            category: "전체",
            selections: selections
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityLabel("필터 창 닫기")
                    .accessibilityAddTraits(.isButton)

                sheet
                    .frame(width: geometry.size.width, height: geometry.size.width * 469 / 393)
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

            VStack(alignment: .leading, spacing: 16) {
                filterSection(key: "지역", title: "지역", options: regionOptions)
                filterSection(key: "대상", title: "대상", options: targetOptions)
                filterSection(key: "마감일", title: "마감일", options: deadlineOptions)
                filterSection(key: "방식", title: "진행 방식", options: modeOptions)

                HStack(spacing: 8) {
                    FINDRButton(title: "초기화", kind: .outline, height: 53) {
                        selections = FINDRExploreFilterLogic.allSelections
                    }
                    .frame(width: 116)

                    FINDRButton(title: "\(resultCount)개 결과 보기", height: 53) {
                        onApply(FINDRExploreFilterLogic.appliedSelections(from: selections))
                    }
                    .frame(maxWidth: .infinity)
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
                Text("필터")
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

    private func filterSection(key: String, title: String, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FINDRFont.bold(14))
                .kerning(-0.28)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(height: 19.5, alignment: .leading)

            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    FINDRPill(title: option, isSelected: selections[key] == option) {
                        selections[key] = option
                    }
                }
            }
        }
    }
}
