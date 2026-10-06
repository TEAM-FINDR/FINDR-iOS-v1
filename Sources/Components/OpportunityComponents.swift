import SwiftUI

struct OpportunityArtworkTile: View {
    let artwork: OpportunityArtwork
    var size: CGFloat = 68
    var iconSize: CGFloat = 26

    var body: some View {
        RoundedRectangle(cornerRadius: size > 64 ? 12 : 10, style: .continuous)
            .fill(LinearGradient(gradient: artwork.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay {
                FINDRIcon(name: artwork.icon, size: iconSize, tint: .white)
            }
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

struct OpportunityListRow: View {
    let opportunity: Opportunity
    var asCard = false
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                OpportunityArtworkTile(artwork: opportunity.artwork, size: 64, iconSize: 25)
                VStack(alignment: .leading, spacing: 4) {
                    Text(opportunity.title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(opportunity.organization) · \(opportunity.location)")
                        .font(FINDRFont.regular(11))
                        .kerning(-0.2)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .lineLimit(1)
                    HStack(spacing: 7) {
                        Text(opportunity.deadline)
                            .font(FINDRFont.bold(11))
                            .foregroundStyle(opportunity.deadline == "D-3" ? FINDRColor.danger : FINDRColor.brand)
                        FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 4)
                            .frame(maxWidth: 52)
                        Text("\(opportunity.completedConditions)/\(opportunity.totalConditions)")
                            .font(FINDRFont.regular(10))
                            .foregroundStyle(FINDRColor.tertiaryText)
                    }
                }
                VStack(alignment: .trailing, spacing: 10) {
                    FINDRIcon(name: FINDRAssetName.more, size: 16, tint: FINDRColor.inactiveIcon)
                    Spacer(minLength: 0)
                    FINDRStatusBadge(status: opportunity.status)
                }
                .padding(.vertical, 2)
            }
            .padding(asCard ? 12 : 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(asCard ? FINDRColor.surface : .clear)
            .clipShape(RoundedRectangle(cornerRadius: asCard ? 16 : 0, style: .continuous))
            .overlay(alignment: .bottom) {
                if !asCard { FINDRColor.divider.frame(height: 1).padding(.leading, 76) }
            }
            .overlay {
                if asCard {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(FINDRColor.border, lineWidth: 1)
                }
            }
            .shadow(color: .black.opacity(asCard ? 0.04 : 0), radius: 16, x: 0, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct FeaturedOpportunityCard: View {
    let opportunity: Opportunity
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
                        ForEach(opportunity.categories.prefix(3), id: \.self) { category in
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
