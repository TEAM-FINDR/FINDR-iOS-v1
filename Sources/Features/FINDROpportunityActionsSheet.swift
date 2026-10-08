import SwiftUI

struct FINDROpportunityActionsSheetOverlay: View {
    let opportunity: Opportunity
    let onDismiss: () -> Void
    let onSave: () -> Void
    let onIgnore: () -> Void
    let onReport: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityLabel("더보기 창 닫기")
                    .accessibilityAddTraits(.isButton)

                sheet
                    .frame(width: geometry.size.width, height: geometry.size.width * 354 / 393)
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

            VStack(spacing: 16) {
                Button(action: onSave) {
                    actionRow(
                        title: "저장하기",
                        iconName: FINDRAssetName.exploreActionBookmark
                    )
                }
                .buttonStyle(.plain)
                .accessibilityHint("저장한 기회에 추가합니다")

                ShareLink(item: opportunity.title) {
                    actionRow(title: "공유하기", iconName: FINDRAssetName.exploreActionShare)
                }
                .buttonStyle(.plain)

                Button(action: onIgnore) {
                    actionRow(title: "관심 없음", iconName: FINDRAssetName.exploreActionIgnore)
                }
                .buttonStyle(.plain)
                .accessibilityHint("탐색 목록에서 이 기회를 숨깁니다")

                Button(action: onReport) {
                    actionRow(
                        title: "신고하기",
                        iconName: FINDRAssetName.exploreActionReport,
                        titleColor: FINDRColor.danger
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)

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
                Text(opportunity.title)
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(1)
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

    private func actionRow(
        title: String,
        iconName: String,
        titleColor: Color = FINDRColor.primaryText
    ) -> some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .frame(width: 22, height: 22)
                .accessibilityHidden(true)

            Text(title)
                .font(FINDRFont.medium(15))
                .kerning(-0.3)
                .foregroundStyle(titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .frame(height: 54)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
