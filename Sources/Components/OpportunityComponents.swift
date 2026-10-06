import SwiftUI

struct OpportunityArtworkTile: View {
    let artwork: OpportunityArtwork
    var size: CGFloat = 68
    var iconSize: CGFloat = 26

    var body: some View {
        RoundedRectangle(cornerRadius: size > 64 ? 12 : 10, style: .continuous)
            .fill(LinearGradient(colors: artwork.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
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
                    HStack(spacing: 5) {
                        ForEach(opportunity.categories.prefix(3), id: \.self) { category in
                            FINDRTag(title: category, tone: .neutral, font: FINDRFont.regular(11), horizontalPadding: 7, verticalPadding: 4)
                        }
                    }
                    HStack(spacing: 6) {
                        FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 4)
                        Text("\(opportunity.completedConditions)/\(opportunity.totalConditions) 조건 충족")
                            .font(FINDRFont.bold(10))
                            .foregroundStyle(opportunity.status.tone.foreground)
                            .fixedSize()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                OpportunityArtworkTile(artwork: opportunity.artwork, size: 78, iconSize: 28)
            }
            .padding(16)
            .background(FINDRColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct CompactOpportunityCard: View {
    let opportunity: Opportunity
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 7) {
                Text(opportunity.title)
                    .font(FINDRFont.bold(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                    .lineLimit(2)
                    .frame(height: 38, alignment: .topLeading)
                Text(opportunity.deadline)
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(opportunity.status == .missing ? FINDRColor.danger : FINDRColor.brand)
                HStack(spacing: 4) {
                    Text("\(opportunity.completedConditions)/\(opportunity.totalConditions)")
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(opportunity.status.tone.foreground)
                    Text("조건 충족")
                        .font(FINDRFont.regular(11))
                        .foregroundStyle(FINDRColor.secondaryText)
                }
                FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 4)
            }
            .padding(14)
            .frame(width: 160, height: 126, alignment: .leading)
            .background(FINDRColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.035), radius: 12, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
