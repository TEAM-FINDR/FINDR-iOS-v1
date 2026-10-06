import SwiftUI

struct MyConditionAddSheet: View {
    @Environment(\.dismiss) private var dismiss
    let ownedConditions: Set<FINDRProfileCondition>
    let onAdd: (FINDRProfileCondition) -> Void

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader

            Text("추가한 조건은 지원 가능 여부 계산에 바로 반영돼요.")
                .font(FINDRFont.regular(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.secondaryText)
                .lineLimit(1)
                .frame(height: 18, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.bottom, FINDRSpacing.small)

            VStack(spacing: 0) {
                ForEach(FINDRProfileCondition.allCases) { condition in
                    conditionRow(condition)
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(FINDRColor.surface.ignoresSafeArea())
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottom) {
            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
                .padding(.bottom, 8)
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private var sheetHeader: some View {
        ZStack(alignment: .top) {
            HStack {
                Text("보유 조건 추가")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                Spacer(minLength: 0)

                Button { dismiss() } label: {
                    FINDRIcon(name: FINDRAssetName.aPathClose, size: 22, tint: FINDRColor.primaryText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }
            .frame(height: 24)
            .padding(.top, 25)

            Capsule()
                .fill(FINDRColor.track)
                .frame(width: 36, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, FINDRSpacing.small)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.bottom, FINDRSpacing.medium)
        .frame(height: 61, alignment: .top)
    }

    private func conditionRow(_ condition: FINDRProfileCondition) -> some View {
        let isOwned = ownedConditions.contains(condition)

        return Button {
            guard !isOwned else { return }
            onAdd(condition)
            dismiss()
        } label: {
            HStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: condition.iconName, size: 20, tint: FINDRColor.secondaryText)
                Text(condition.shortTitle)
                    .font(FINDRFont.medium(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                Spacer(minLength: 0)
                FINDRIcon(name: FINDRAssetName.chevronRight, size: 16, tint: FINDRColor.inactiveIcon)
            }
            .padding(.horizontal, FINDRSpacing.large)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(condition.shortTitle), \(isOwned ? "보유 중" : "추가")")
        .accessibilityHint(isOwned ? "이미 보유 중인 조건입니다." : "보유 조건에 추가합니다.")
    }
}
