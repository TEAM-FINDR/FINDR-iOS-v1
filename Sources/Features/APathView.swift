import SwiftUI

struct APathView: View {
    let completedActions: Set<APathActionID>
    let onOpenSimulator: () -> Void
    let onOpenAction: (APathActionID) -> Void

    @State private var selectedCategory = APathCategory.recommended.rawValue
    @State private var showHelp = false

    private var selectedAPathCategory: APathCategory {
        APathCategory(rawValue: selectedCategory) ?? .recommended
    }

    private var visibleActions: [APathActionID] {
        APathActionID.actions(for: selectedAPathCategory)
    }

    private var previewAction: APathActionID {
        completedActions.contains(.portfolio) ? .computerLiteracy : .portfolio
    }

    private var whatIfConditions: Set<APathConditionID> {
        var conditions = Set(completedActions.compactMap(\.conditionID))
        if let condition = previewAction.conditionID {
            conditions.insert(condition)
        }
        return conditions
    }

    private var currentOpportunityCount: Int {
        APathOpportunityProjection.currentCount(completedActions: completedActions)
    }

    private var projectedOpportunityCount: Int {
        APathOpportunityProjection.projectedCount(
            selectedConditions: whatIfConditions,
            completedActions: completedActions
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
                header
                whatIfCard
                Text("지금 할 수 있는 활동이 새로운 기회를 만들어요.")
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .padding(.top, 2)
                categoryTabs
                VStack(spacing: FINDRSpacing.small) {
                    ForEach(visibleActions, id: \.self) { actionID in
                        actionCard(actionID)
                    }
                }
                .padding(.bottom, FINDRSpacing.medium)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 14)
        }
        .background(FINDRColor.canvas)
        .sheet(isPresented: $showHelp) {
            APathHelpSheet(onClose: { showHelp = false })
                .presentationDetents([.height(330)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(36)
        }
    }

    private var header: some View {
        FINDRPageHeader(
            title: "A-Path",
            trailingIcon: FINDRAssetName.aPathHelp,
            trailingLabel: "A-Path 도움말",
            action: { showHelp = true },
            trailingSize: 21
        )
    }

    private var whatIfCard: some View {
        Button(action: onOpenSimulator) {
            VStack(spacing: FINDRSpacing.medium) {
                Text("What-if")
                    .font(FINDRFont.bold(10))
                    .foregroundStyle(FINDRColor.brand)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(FINDRColor.surface, in: Capsule())

                Text(previewTitle)
                    .font(FINDRFont.bold(16))
                    .kerning(-0.32)
                    .foregroundStyle(FINDRColor.primaryText)

                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("현재")
                            .font(FINDRFont.regular(11))
                            .foregroundStyle(FINDRColor.secondaryText)
                        Text("\(currentOpportunityCount)개")
                            .font(FINDRFont.bold(28))
                            .foregroundStyle(FINDRColor.primaryText)
                    }
                    FINDRIcon(name: FINDRAssetName.pathArrow, size: 18, tint: FINDRColor.inactiveIcon)
                    VStack(spacing: 2) {
                        Text("완료 후")
                            .font(FINDRFont.regular(11))
                            .foregroundStyle(FINDRColor.brand)
                        Text("\(projectedOpportunityCount)개")
                            .font(FINDRFont.bold(28))
                            .foregroundStyle(FINDRColor.brand)
                    }
                }

                Text("+\(projectedOpportunityCount - currentOpportunityCount)개의 새로운 기회")
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(FINDRColor.brandButton, in: Capsule())

                HStack(spacing: 6) {
                    ForEach(previewAction.breakdown) { item in
                        breakdown(item.category, "+\(item.count)")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FINDRSpacing.large)
            .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("What-if 시뮬레이터, \(currentOpportunityCount)개에서 \(projectedOpportunityCount)개")
        .accessibilityIdentifier("apath-open-simulator")
    }

    private var previewTitle: String {
        previewAction == .portfolio ? "포트폴리오를 만든다면?" : "컴퓨터활용능력 2급을 취득한다면?"
    }

    private func breakdown(_ category: String, _ count: String) -> some View {
        HStack(spacing: 3) {
            Text(category).foregroundStyle(FINDRColor.secondaryText)
            Text(count).font(FINDRFont.bold(11)).foregroundStyle(FINDRColor.brand)
        }
        .font(FINDRFont.regular(11))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .fixedSize()
    }

    private var categoryTabs: some View {
        FINDRUnderlineTabs(
            titles: APathCategory.allCases.map(\.rawValue),
            selection: $selectedCategory,
            fontSize: 13,
            itemSpacing: 18,
            indicatorSpacing: 8,
            equalWidth: false,
            unselectedTextColor: FINDRColor.secondaryText,
            unselectedIndicatorColor: .clear,
            showsBottomDivider: true
        )
    }

    private func actionCard(_ actionID: APathActionID) -> some View {
        Button {
            onOpenAction(actionID)
        } label: {
            HStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: actionID.iconName, size: 20, tint: actionID.iconTint)
                    .frame(width: 44, height: 44)
                    .background(actionID.iconBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedAPathCategory == .certificate ? actionID.categoryTitle : actionID.title)
                        .font(FINDRFont.bold(14))
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                    Text(actionID.subtitle)
                        .font(FINDRFont.regular(11))
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .lineLimit(1)
                }

                Spacer(minLength: FINDRSpacing.small)

                VStack(alignment: .trailing, spacing: 0) {
                    if completedActions.contains(actionID) {
                        Text("완료")
                            .font(FINDRFont.bold(12))
                            .foregroundStyle(FINDRColor.success)
                    } else {
                        Text("+\(actionID.opportunityCount)개")
                            .font(FINDRFont.bold(14))
                            .foregroundStyle(FINDRColor.brand)
                    }
                    Text("기회")
                        .font(FINDRFont.regular(10))
                        .foregroundStyle(FINDRColor.tertiaryText)
                }
            }
            .padding(14)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("apath-action-\(actionID.id)")
    }
}

private struct APathHelpSheet: View {
    let onClose: () -> Void

    private let instructions = [
        ("지금 가능한 기회를 계산해요", "프로필 조건과 1,200개 기회의 지원 조건을 비교해요."),
        ("부족한 조건을 찾아요", "지원하지 못하는 기회에서 부족한 조건을 모아요."),
        ("다음 행동을 추천해요", "가장 많은 기회를 여는 행동부터 순서대로 보여드려요.")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            HStack {
                Text("A-Path는 이렇게 작동해요")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                Spacer()
                Button(action: onClose) {
                    FINDRIcon(name: FINDRAssetName.aPathClose, size: 22, tint: FINDRColor.secondaryText)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }

            VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
                ForEach(instructions.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: FINDRSpacing.medium) {
                        Text("\(index + 1)")
                            .font(FINDRFont.bold(12))
                            .foregroundStyle(FINDRColor.brand)
                            .frame(width: 28, height: 28)
                            .background(FINDRColor.brandSubtle, in: Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(instructions[index].0)
                                .font(FINDRFont.bold(13))
                                .foregroundStyle(FINDRColor.primaryText)
                            Text(instructions[index].1)
                                .font(FINDRFont.regular(11))
                                .foregroundStyle(FINDRColor.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            FINDRButton(title: "알겠어요", action: onClose)
                .padding(.top, FINDRSpacing.xSmall)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.large)
        .padding(.bottom, FINDRSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.surface.ignoresSafeArea())
    }
}
