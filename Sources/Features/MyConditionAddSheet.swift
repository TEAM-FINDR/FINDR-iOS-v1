import SwiftUI

struct MyConditionAddSheet: View {
    @Environment(\.dismiss) private var dismiss
    let ownedConditions: Set<FINDRProfileCondition>
    let onAdd: (FINDRProfileCondition) -> Void

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: FINDRSpacing.xSmall) {
                    Text("보유 조건 추가")
                        .font(FINDRFont.bold(20))
                        .foregroundStyle(FINDRColor.primaryText)
                    Text("보유한 조건을 선택해주세요")
                        .font(FINDRFont.regular(13))
                        .foregroundStyle(FINDRColor.secondaryText)
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(FINDRColor.secondaryText)
                        .frame(width: 32, height: 32)
                        .background(FINDRColor.subtle, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }

            LazyVGrid(columns: columns, spacing: FINDRSpacing.small) {
                ForEach(FINDRProfileCondition.allCases) { condition in
                    conditionButton(condition)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 28)
        .padding(.bottom, FINDRSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.surface.ignoresSafeArea())
    }

    private func conditionButton(_ condition: FINDRProfileCondition) -> some View {
        let isOwned = ownedConditions.contains(condition)

        return Button {
            guard !isOwned else { return }
            onAdd(condition)
            dismiss()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    FINDRIcon(
                        name: condition.iconName,
                        size: 24,
                        tint: isOwned ? FINDRColor.tertiaryText : FINDRColor.brand
                    )
                    Spacer()
                    FINDRIcon(
                        name: isOwned ? FINDRAssetName.checkCircle : FINDRAssetName.plus,
                        size: 18,
                        tint: isOwned ? FINDRColor.success : FINDRColor.brand
                    )
                }
                Text(condition.title)
                    .font(FINDRFont.medium(12))
                    .foregroundStyle(isOwned ? FINDRColor.tertiaryText : FINDRColor.primaryText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
            .background(isOwned ? FINDRColor.subtle : FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isOwned ? FINDRColor.border : FINDRColor.borderStrong, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isOwned)
        .accessibilityLabel("\(condition.title), \(isOwned ? "보유 중" : "추가")")
    }
}
