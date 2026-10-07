import SwiftUI

struct SavedOpportunityActionsSheetOverlay: View {
    let opportunity: Opportunity
    let onDismiss: () -> Void
    let onOpenReminderSettings: () -> Void
    let onRemove: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityLabel("저장한 기회 메뉴 닫기")
                    .accessibilityAddTraits(.isButton)

                sheet
                    .frame(width: geometry.size.width, height: geometry.size.width * 252 / 393)
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

            VStack(spacing: 0) {
                Button(action: onOpenReminderSettings) {
                    actionRow(title: "마감 알림 설정", iconName: FINDRAssetName.savedReminder)
                }
                .buttonStyle(.plain)

                shareAction

                Button(action: onRemove) {
                    actionRow(
                        title: "저장 취소",
                        iconName: FINDRAssetName.savedRemove,
                        titleColor: FINDRColor.danger
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)

            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(FINDRColor.surface)
    }

    @ViewBuilder
    private var shareAction: some View {
        if let shareURL = opportunity.shareURL {
            ShareLink(item: shareURL, subject: Text(opportunity.title), preview: SharePreview(opportunity.title)) {
                actionRow(title: "공유하기", iconName: FINDRAssetName.exploreActionShare)
            }
            .buttonStyle(.plain)
        } else {
            ShareLink(item: opportunity.title, subject: Text(opportunity.title)) {
                actionRow(title: "공유하기", iconName: FINDRAssetName.exploreActionShare)
            }
            .buttonStyle(.plain)
        }
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
