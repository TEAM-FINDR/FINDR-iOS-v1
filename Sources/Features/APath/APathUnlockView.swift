import SwiftUI

struct APathUnlockView: View {
    let actionID: APathActionID
    let onOpenOpportunity: (Opportunity) -> Void
    let onGoHome: () -> Void
    let onViewOpportunities: () -> Void

    private var opportunities: [Opportunity] {
        Opportunity.aPathUnlockedSamples(for: actionID)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    FINDRIcon(name: FINDRAssetName.aPathUnlock, size: 44, tint: FINDRColor.successStatus)
                        .frame(width: 104, height: 104)
                        .background(FINDRColor.successSubtle, in: Circle())
                        .padding(.top, 32)

                    Text("새로운 기회 \(actionID.opportunityCount)개가 열렸어요!")
                        .font(FINDRFont.bold(22))
                        .kerning(-0.44)
                        .foregroundStyle(FINDRColor.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.top, FINDRSpacing.medium)
                        .accessibilityIdentifier("apath-unlocked-title")

                    Text("\(actionID.title) 보유 조건이 추가되었어요.\n지금 바로 지원할 수 있어요.")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, FINDRSpacing.small)

                    if !opportunities.isEmpty {
                        VStack(spacing: FINDRSpacing.medium) {
                            ForEach(opportunities) { opportunity in
                                unlockedOpportunityRow(opportunity)
                            }
                        }
                        .padding(.horizontal, FINDRSpacing.screen)
                        .padding(.top, 36)
                        .padding(.bottom, FINDRSpacing.large)
                    }
                }
                .frame(maxWidth: .infinity)
            }

            bottomCTA
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FINDRColor.surface)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func unlockedOpportunityRow(_ opportunity: Opportunity) -> some View {
        Button {
            onOpenOpportunity(opportunity)
        } label: {
            HStack(spacing: FINDRSpacing.medium) {
                OpportunityArtworkTile(artwork: opportunity.artwork, size: 64, iconSize: 25)

                VStack(alignment: .leading, spacing: 4) {
                    Text(opportunity.title)
                        .font(FINDRFont.bold(14))
                        .kerning(-0.28)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(opportunity.organization) · \(opportunity.location)")
                        .font(FINDRFont.regular(11))
                        .kerning(-0.22)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .lineLimit(1)

                    Text(opportunity.deadline)
                        .font(FINDRFont.bold(11))
                        .foregroundStyle(FINDRColor.brand)
                }

                VStack(alignment: .trailing, spacing: 12) {
                    FINDRIcon(name: FINDRAssetName.aPathMore, size: 18, tint: FINDRColor.inactiveIcon)
                    FINDRStatusBadge(status: .eligible)
                }
                .padding(.vertical, 2)
            }
            .frame(maxWidth: .infinity, minHeight: 72)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("apath-unlocked-\(opportunity.id)")
    }

    private var bottomCTA: some View {
        HStack(spacing: FINDRSpacing.small) {
            FINDRButton(title: "홈으로", kind: .outline, action: onGoHome)
                .frame(width: 116)
            FINDRButton(
                title: "열린 기회 \(actionID.opportunityCount)개 보기",
                action: onViewOpportunities
            )
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
}
