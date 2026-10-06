import SwiftUI

struct APathSimulatorView: View {
    let completedActions: Set<APathActionID>
    let onStartPortfolio: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedConditions = APathOpportunityProjection.defaultSelectedConditions

    private var currentCount: Int {
        APathOpportunityProjection.currentCount(completedActions: completedActions)
    }

    private var projectedCount: Int {
        APathOpportunityProjection.projectedCount(
            selectedConditions: selectedConditions,
            completedActions: completedActions
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            APathSubpageHeader(title: "What-if", onBack: { dismiss() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                    Text("조건을 켜보면 새로 열리는 기회를 미리 볼 수 있어요.")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.secondaryText)

                    projectionCard
                    conditionList
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
                .padding(.bottom, FINDRSpacing.large)
            }

            bottomCTA
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.canvas)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var projectionCard: some View {
        VStack(spacing: FINDRSpacing.medium) {
            HStack(alignment: .center, spacing: 20) {
                countColumn(title: "현재", count: currentCount, tint: FINDRColor.primaryText)
                FINDRIcon(name: FINDRAssetName.aPathArrowRight, size: 22, tint: FINDRColor.inactiveIcon)
                    .padding(.top, FINDRSpacing.large)
                countColumn(title: "적용 시", count: projectedCount, tint: FINDRColor.brand)
            }

            Text("+\(projectedCount - currentCount)개의 새로운 기회")
                .font(FINDRFont.bold(11))
                .kerning(-0.22)
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(FINDRColor.brandButton, in: Capsule())
                .accessibilityIdentifier("apath-simulation-delta")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func countColumn(title: String, count: Int, tint: Color) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(FINDRFont.regular(11))
                .foregroundStyle(title == "적용 시" ? FINDRColor.brand : FINDRColor.secondaryText)
            Text("\(count)개")
                .font(FINDRFont.bold(28))
                .kerning(-0.56)
                .foregroundStyle(tint)
                .contentTransition(.numericText())
                .accessibilityIdentifier(title == "현재" ? "apath-current-count" : "apath-projected-count")
        }
        .frame(minWidth: 58)
    }

    private var conditionList: some View {
        VStack(spacing: 0) {
            ForEach(APathConditionID.allCases, id: \.self) { condition in
                conditionRow(condition)
                if condition != .seoul {
                    FINDRColor.divider
                        .frame(height: 1)
                        .padding(.leading, 52)
                }
            }
        }
        .padding(.horizontal, FINDRSpacing.medium)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(FINDRColor.border, lineWidth: 1)
        }
    }

    private func conditionRow(_ condition: APathConditionID) -> some View {
        let isSelected = selectedConditions.contains(condition)

        return HStack(spacing: FINDRSpacing.medium) {
            FINDRIcon(name: condition.iconName, size: 20, tint: FINDRColor.secondaryText)
                .frame(width: 20, height: 20)

            Text("\(condition.title) · +\(condition.opportunityCount)")
                .font(FINDRFont.medium(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                toggle(condition)
            } label: {
                Image(isSelected ? FINDRAssetName.aPathToggleOn : FINDRAssetName.aPathToggleOff)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 51, height: 31)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(condition.title)
            .accessibilityValue(isSelected ? "켜짐" : "꺼짐")
            .accessibilityIdentifier("apath-condition-\(condition.id)")
        }
        .frame(height: 54)
    }

    private var bottomCTA: some View {
        VStack(spacing: 0) {
            FINDRButton(title: "포트폴리오부터 시작하기", action: onStartPortfolio)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.medium)
        .padding(.bottom, FINDRSpacing.small)
        .background {
            FINDRColor.surface
                .overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private func toggle(_ condition: APathConditionID) {
        if selectedConditions.contains(condition) {
            selectedConditions.remove(condition)
        } else {
            selectedConditions.insert(condition)
        }
    }
}

struct APathSubpageHeader: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                FINDRIcon(name: FINDRAssetName.aPathBack, size: 24, tint: FINDRColor.primaryText)
                    .frame(width: 24, height: 24)
                    .frame(width: 40, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로")

            Text(title)
                .font(FINDRFont.bold(14))
                .kerning(-0.28)
                .foregroundStyle(FINDRColor.primaryText)
                .frame(maxWidth: .infinity)

            Color.clear
                .frame(width: 40, height: 24)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .frame(height: 40)
    }
}
