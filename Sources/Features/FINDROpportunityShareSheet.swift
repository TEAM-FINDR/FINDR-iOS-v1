import SwiftUI

struct FINDROpportunityShareSheetOverlay: View {
    let opportunity: Opportunity
    let onDismiss: () -> Void
    let onCopyLink: (URL?) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                FINDRColor.scrim
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(perform: onDismiss)
                    .accessibilityLabel("공유 창 닫기")
                    .accessibilityAddTraits(.isButton)

                sheet
                    .frame(width: geometry.size.width, height: geometry.size.width * 271 / 393)
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
                HStack(spacing: 0) {
                    shareDestination(title: "카카오톡", symbol: nil, usesKakaoStyle: true)
                    Spacer(minLength: 0)
                    shareDestination(
                        title: "링크 복사",
                        symbol: FINDRAssetName.detailShareLink,
                        isCopyAction: true
                    )
                    Spacer(minLength: 0)
                    shareDestination(title: "메시지", symbol: FINDRAssetName.detailShareMail)
                    Spacer(minLength: 0)
                    shareDestination(title: "더보기", symbol: FINDRAssetName.detailShareMore)
                }

                previewCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)

            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
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
                Text("공유하기")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: onDismiss) {
                    FINDRIcon(name: FINDRAssetName.aPathClose, size: 22, tint: FINDRColor.tertiaryText)
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

    @ViewBuilder
    private func shareDestination(
        title: String,
        symbol: String?,
        usesKakaoStyle: Bool = false,
        isCopyAction: Bool = false
    ) -> some View {
        if isCopyAction {
            Button {
                onCopyLink(opportunity.shareURL)
            } label: {
                destinationContent(title: title, symbol: symbol, usesKakaoStyle: usesKakaoStyle)
            }
            .buttonStyle(.plain)
            .accessibilityHint(opportunity.shareURL == nil ? "공유 링크가 등록되지 않았습니다" : "공유 링크를 클립보드에 복사합니다")
        } else if let shareURL = opportunity.shareURL {
            ShareLink(item: shareURL, subject: Text(opportunity.title), preview: SharePreview(opportunity.title)) {
                destinationContent(title: title, symbol: symbol, usesKakaoStyle: usesKakaoStyle)
            }
            .buttonStyle(.plain)
            .accessibilityHint("공유할 앱을 선택합니다")
        } else {
            ShareLink(item: opportunity.title, subject: Text(opportunity.title)) {
                destinationContent(title: title, symbol: symbol, usesKakaoStyle: usesKakaoStyle)
            }
            .buttonStyle(.plain)
            .accessibilityHint("공유할 앱을 선택합니다")
        }
    }

    private func destinationContent(
        title: String,
        symbol: String?,
        usesKakaoStyle: Bool
    ) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(usesKakaoStyle ? Color(hex: 0xFEE500) : FINDRColor.subtle)
                    .frame(width: 56, height: 56)

                if usesKakaoStyle {
                    Text("TALK")
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(Color(hex: 0x191919))
                } else if let symbol {
                    FINDRIcon(name: symbol, size: 22, tint: FINDRColor.primaryText)
                }
            }

            Text(title)
                .font(FINDRFont.regular(12))
                .kerning(-0.24)
                .foregroundStyle(FINDRColor.secondaryText)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .frame(width: 56)
        .contentShape(Rectangle())
    }

    private var previewCard: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: opportunity.artwork.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(opportunity.title)
                    .font(FINDRFont.bold(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(1)

                Text(opportunity.shareURL?.absoluteString ?? "공유 링크 미등록")
                    .font(FINDRFont.regular(12))
                    .kerning(-0.24)
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 68, maxHeight: 68, alignment: .leading)
        .background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
