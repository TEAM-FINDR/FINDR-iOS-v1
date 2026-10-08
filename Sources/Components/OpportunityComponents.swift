import SwiftUI

struct OpportunityArtworkTile: View {
    let artwork: OpportunityArtwork
    var size: CGFloat = 68
    var iconSize: CGFloat = 26
    var cornerRadius: CGFloat? = nil

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius ?? (size > 64 ? 12 : 10), style: .continuous)
            .fill(LinearGradient(gradient: artwork.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay {
                FINDRIcon(name: artwork.icon, size: iconSize, tint: artwork.iconTint)
            }
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

struct OpportunityListRow: View {
    let opportunity: Opportunity
    var asCard = false
    var showsProgress = true
    var showsLocation = true
    var showsDivider = true
    var rowHeight: CGFloat = 93
    var informationSpacing: CGFloat = 3
    var trailingSpacing: CGFloat? = nil
    var artworkCornerRadius: CGFloat? = nil
    var moreIconName = FINDRAssetName.more
    var onMore: (() -> Void)? = nil
    var onTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    OpportunityArtworkTile(
                        artwork: opportunity.artwork,
                        size: asCard ? 68 : 64,
                        iconSize: asCard ? 26 : 24,
                        cornerRadius: artworkCornerRadius
                    )
                    VStack(alignment: .leading, spacing: informationSpacing) {
                        Text(opportunity.title)
                            .font(FINDRFont.bold(15))
                            .kerning(-0.3)
                            .foregroundStyle(FINDRColor.primaryText)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(showsLocation ? "\(opportunity.organization) · \(opportunity.location)" : opportunity.organization)
                            .font(FINDRFont.regular(12))
                            .kerning(-0.24)
                            .foregroundStyle(FINDRColor.tertiaryText)
                            .lineLimit(1)
                        HStack(spacing: asCard ? 8 : 7) {
                            Text(opportunity.deadline)
                                .font(FINDRFont.bold(12))
                                .foregroundStyle(opportunity.deadline == "D-3" ? FINDRColor.danger : FINDRColor.brand)
                            if showsProgress {
                                FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 4)
                                    .frame(maxWidth: asCard ? 60 : 52)
                                Text("\(opportunity.completedConditions)/\(opportunity.totalConditions)")
                                    .font(asCard ? FINDRFont.medium(11) : FINDRFont.regular(10))
                                    .foregroundStyle(FINDRColor.tertiaryText)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)

            VStack(alignment: .trailing, spacing: trailingSpacing ?? (asCard ? 22 : 18)) {
                if let onMore {
                    Button(action: onMore) {
                        moreIcon
                            .frame(width: 24, height: 24)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("더보기")
                } else {
                    moreIcon
                }

                FINDRStatusBadge(status: opportunity.status)
            }
        }
        .padding(asCard ? 14 : 0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: asCard ? nil : rowHeight)
        .background(asCard ? FINDRColor.surface : .clear)
        .clipShape(RoundedRectangle(cornerRadius: asCard ? 16 : 0, style: .continuous))
        .overlay(alignment: .bottom) {
            if !asCard && showsDivider { FINDRColor.divider.frame(height: 1).padding(.leading, 76) }
        }
        .overlay {
            if asCard {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
        }
        .shadow(color: asCard ? FINDRShadow.card : .clear, radius: 18, x: 0, y: 4)
    }

    private var moreIcon: some View {
        FINDRIcon(name: moreIconName, size: 18, tint: FINDRColor.inactiveIcon)
    }
}

struct HomeNearlyEligibleOpportunityCard: View {
    let opportunity: Opportunity
    let onOpenOpportunity: () -> Void
    let onPrepare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Button(action: onOpenOpportunity) {
                    Text(opportunity.title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)

                FINDRStatusBadge(status: .nearlyEligible)
            }
            .frame(height: 24)

            Text("\(opportunity.organization) · \(opportunity.location) · \(opportunity.deadline)")
                .font(FINDRFont.regular(12))
                .kerning(-0.24)
                .foregroundStyle(FINDRColor.tertiaryText)
                .lineLimit(1)
                .frame(height: 17, alignment: .leading)

            HStack(spacing: 8) {
                FINDRProgressBar(
                    progress: opportunity.progress,
                    color: FINDRColor.warningStatus,
                    height: 4
                )
                .frame(width: 150)

                Text("\(opportunity.completedConditions)/\(opportunity.totalConditions) 조건 충족")
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(FINDRColor.warning)
                    .fixedSize()
            }
            .frame(height: 17)

            HStack(spacing: 4) {
                HStack(spacing: 4) {
                    FINDRIcon(name: FINDRAssetName.missing, size: 14, tint: FINDRColor.dangerStatus)
                    Text(opportunity.missingCondition ?? "")
                        .font(FINDRFont.medium(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.danger)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                Button(action: onPrepare) {
                    HStack(spacing: 2) {
                        Text("A-Path에서 준비하기")
                            .font(FINDRFont.bold(12))
                            .kerning(-0.24)
                            .foregroundStyle(FINDRColor.brand)
                        FINDRIcon(name: FINDRAssetName.chevronRight, size: 14, tint: FINDRColor.brand)
                    }
                }
                .buttonStyle(.plain)
            }
            .frame(height: 17)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(FINDRColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(FINDRColor.border, lineWidth: 1)
        }
        .shadow(color: FINDRShadow.card, radius: 18, x: 0, y: 4)
        .accessibilityElement(children: .contain)
    }
}

struct HomeDeadlineAlertBanner: View {
    let onOpenNotificationSettings: () -> Void

    var body: some View {
        Button(action: onOpenNotificationSettings) {
            HStack(spacing: 8) {
                FINDRIcon(name: FINDRAssetName.clock, size: 18, tint: FINDRColor.dangerStatus)

                Text("7일 안에 마감되는 기회 5개")
                    .font(FINDRFont.medium(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.danger)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Text("알림 설정")
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(FINDRColor.danger)
                    .fixedSize()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FINDRColor.dangerSubtle, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("7일 안에 마감되는 기회 5개, 알림 설정")
    }
}

struct OpportunityFeedRow: View {
    let opportunity: Opportunity
    var artworkOverride: OpportunityArtwork? = nil
    let onOpenOpportunity: () -> Void

    private var isCriticalDeadline: Bool {
        guard opportunity.deadline.hasPrefix("D-"),
              let daysRemaining = Int(opportunity.deadline.dropFirst(2)) else { return false }
        return daysRemaining <= 5
    }

    var body: some View {
        Button(action: onOpenOpportunity) {
            HStack(spacing: 12) {
                OpportunityArtworkTile(artwork: artworkOverride ?? opportunity.artwork, size: 64, iconSize: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(opportunity.title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(opportunity.organization) · \(opportunity.location)")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .lineLimit(1)

                    Text(opportunity.deadline)
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(isCriticalDeadline ? FINDRColor.danger : FINDRColor.brand)
                }

                VStack(alignment: .trailing, spacing: 20) {
                    FINDRIcon(name: FINDRAssetName.aPathMore, size: 18, tint: FINDRColor.inactiveIcon)
                    FINDRStatusBadge(status: opportunity.status)
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 88)
            .background(FINDRColor.surface)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct FeaturedOpportunityCard: View {
    let opportunity: Opportunity
    var categoryLabels: [String]? = nil
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(opportunity.title)
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        FINDRTag(title: opportunity.deadline, tone: .danger, font: FINDRFont.bold(11), horizontalPadding: 8, verticalPadding: 3)
                        Text("10.08 마감")
                            .font(FINDRFont.regular(11))
                            .foregroundStyle(FINDRColor.tertiaryText)
                    }
                    HStack(spacing: 4) {
                        ForEach((categoryLabels ?? opportunity.categories).prefix(3), id: \.self) { category in
                            FINDRTag(
                                title: category,
                                tone: .neutral,
                                font: FINDRFont.regular(12),
                                kerning: -0.24,
                                horizontalPadding: 8,
                                verticalPadding: 4
                            )
                        }
                    }
                    .frame(height: 25)
                    HStack(spacing: 6) {
                        FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 4)
                            .frame(width: 120)
                        Text("\(opportunity.completedConditions)/\(opportunity.totalConditions) 조건 충족")
                            .font(FINDRFont.bold(11))
                            .foregroundStyle(opportunity.status.tone.foreground)
                            .fixedSize()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                OpportunityArtworkTile(artwork: opportunity.artwork, size: 84, iconSize: 32)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .frame(height: 143)
            .background(FINDRColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .shadow(color: FINDRShadow.card, radius: 18, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct CompactOpportunityCard: View {
    let opportunity: Opportunity
    var onTap: () -> Void = {}

    private var conditionProgressTone: FINDRTagTone {
        if opportunity.status == .eligible { return .success }
        if opportunity.progress >= 0.75 { return .brand }
        if opportunity.progress >= 0.5 { return .warning }
        return .danger
    }

    private var conditionProgressColor: Color {
        switch conditionProgressTone {
        case .neutral: FINDRColor.secondaryText
        case .brand: FINDRColor.brand
        case .success: FINDRColor.successStatus
        case .warning: FINDRColor.warningStatus
        case .danger: FINDRColor.dangerStatus
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(opportunity.title)
                    .font(FINDRFont.bold(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(2, reservesSpace: true)
                    .lineSpacing(-2)
                    .frame(height: 39, alignment: .topLeading)
                Text(opportunity.deadline)
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(opportunity.status == .missing ? FINDRColor.danger : FINDRColor.brand)
                    .frame(height: 17, alignment: .leading)
                HStack(spacing: 4) {
                    Text("\(opportunity.completedConditions)/\(opportunity.totalConditions)")
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(conditionProgressTone.foreground)
                    Text("조건 충족")
                        .font(FINDRFont.regular(12))
                        .foregroundStyle(FINDRColor.secondaryText)
                        .kerning(-0.24)
                    Spacer(minLength: 0)
                }
                .frame(height: 17)
                FINDRProgressBar(progress: opportunity.progress, color: conditionProgressColor, height: 4)
            }
            .padding(14)
            .frame(width: 170.5, height: 130, alignment: .leading)
            .background(FINDRColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .shadow(color: FINDRShadow.card, radius: 18, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
