import SwiftUI

struct OpportunityDetailView: View {
    let opportunity: Opportunity
    @Binding var savedIDs: Set<String>
    let onPrepareWithPath: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection = "상세 정보"
    @State private var showApplyNotice = false

    private let sections = ["상세 정보", "지원 자격", "문의처"]
    private var isSaved: Bool { savedIDs.contains(opportunity.id) }
    private var isMissing: Bool { opportunity.status == .missing }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                navigationHeader
                    .padding(.bottom, 12)
                overview
                sectionSelector
                    .padding(.top, 15)
                sectionContent
                    .padding(.top, 17)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
        .background(FINDRColor.surface)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomActions }
        .toolbar(.hidden, for: .navigationBar)
        .alert("지원 페이지", isPresented: $showApplyNotice) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("지원 링크가 연결되면 여기에서 이동할 수 있어요.")
        }
    }

    private var navigationHeader: some View {
        HStack {
            FINDRIconButton(
                iconName: FINDRAssetName.back,
                accessibilityLabel: "뒤로",
                action: { dismiss() },
                size: 24,
                tint: FINDRColor.primaryText
            )
            .frame(width: 28, height: 32, alignment: .leading)
            Spacer()
            FINDRIconButton(
                iconName: FINDRAssetName.bookmark,
                accessibilityLabel: isSaved ? "저장 취소" : "저장",
                action: toggleSaved,
                tint: isSaved ? FINDRColor.brand : FINDRColor.primaryText
            )
            ShareLink(item: opportunity.title) {
                FINDRIcon(name: FINDRAssetName.share, size: 22, tint: FINDRColor.primaryText)
                    .frame(width: 24, height: 32)
            }
            .padding(.leading, 14)
        }
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            FINDRTag(title: opportunity.deadline, tone: .danger, font: FINDRFont.bold(12), kerning: 0, textHeight: 17, horizontalPadding: 8, verticalPadding: 4)
            Text(opportunity.title)
                .font(FINDRFont.bold(24))
                .kerning(-0.48)
                .foregroundStyle(FINDRColor.primaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 14)
            HStack(spacing: 6) {
                ForEach(opportunity.categories.prefix(3), id: \.self) { category in
                    FINDRTag(title: category, tone: .brand, font: FINDRFont.regular(12), kerning: -0.24, textHeight: 17, horizontalPadding: 8, verticalPadding: 4)
                }
            }
            .padding(.top, 12)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    FINDRIcon(name: FINDRAssetName.building, size: 16, tint: FINDRColor.tertiaryText)
                    Text(opportunity.organization)
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                }
                HStack(spacing: 6) {
                    FINDRIcon(name: FINDRAssetName.calendar, size: 16, tint: FINDRColor.tertiaryText)
                    Text(opportunity.dateRange)
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                }
            }
            .padding(.top, 9)
        }
    }

    private var sectionSelector: some View {
        FINDRUnderlineTabs(
            titles: sections,
            selection: $selectedSection,
            fontSize: 14,
            selectedFont: FINDRFont.bold(14),
            unselectedFont: FINDRFont.medium(14),
            textKerning: -0.28
        )
    }

    @ViewBuilder
    private var sectionContent: some View {
        switch selectedSection {
        case "지원 자격":
            eligibilitySection
        case "문의처":
            VStack(alignment: .leading, spacing: 12) {
                Text("문의처")
                    .font(FINDRFont.bold(16))
                    .foregroundStyle(FINDRColor.primaryText)
                FINDRCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(opportunity.organization)
                            .font(FINDRFont.bold(14))
                            .foregroundStyle(FINDRColor.primaryText)
                        Text("상세 문의 정보는 공고 페이지에서 확인할 수 있어요.")
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.secondaryText)
                    }
                }
            }
        default:
            eligibilitySection
        }
    }

    private var eligibilitySection: some View {
        VStack(alignment: .leading, spacing: 13) {
            statusCard
            VStack(spacing: 0) {
                ForEach(Array(opportunity.conditionNames.enumerated()), id: \.offset) { index, condition in
                    conditionRow(condition, isMissing: condition.localizedCaseInsensitiveContains(opportunity.missingCondition ?? "∅"))
                }
            }
            HStack(spacing: 8) {
                benefitTag(icon: FINDRAssetName.gift, title: "교육비 무료")
                benefitTag(icon: FINDRAssetName.award, title: "수료증 제공")
            }
            if isMissing {
                unlockCallout
                    .padding(.top, 2)
            }
        }
    }

    private var statusCard: some View {
        let isEligible = !isMissing && opportunity.progress >= 1
        let title = isEligible ? "지금, 이 기회에 지원할 수 있어요!" : (opportunity.status == .nearlyEligible ? "조금만 더 준비하면 지원 가능해요" : "포트폴리오만 준비하면 지원 가능해요")
        let tone = isEligible ? FINDRTagTone.success : (opportunity.status == .nearlyEligible ? FINDRTagTone.warning : .warning)
        let iconName = isEligible ? FINDRAssetName.checkCircle : FINDRAssetName.alert
        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(FINDRColor.surface).frame(width: 36, height: 36)
                    FINDRIcon(name: iconName, size: 22, tint: tone.foreground)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(tone.foreground)
                    Text("\(opportunity.completedConditions)/\(opportunity.totalConditions) 조건 충족 · \(Int(opportunity.progress * 100))%")
                        .font(FINDRFont.medium(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                }
            }
            FINDRProgressBar(progress: opportunity.progress, color: opportunity.status.progressColor, height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14.5)
        .background(tone.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func conditionRow(_ title: String, isMissing: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(isMissing ? FINDRColor.dangerSubtle : FINDRColor.brandSubtle).frame(width: 22, height: 22)
                FINDRIcon(name: isMissing ? FINDRAssetName.missing : FINDRAssetName.check, size: 14, tint: isMissing ? FINDRColor.danger : FINDRColor.brand)
            }
            Text(title)
                .font(FINDRFont.regular(14))
                .kerning(-0.28)
                .foregroundStyle(isMissing ? FINDRColor.danger : FINDRColor.primaryText)
                .lineLimit(2)
            Spacer(minLength: 4)
            Text(isMissing ? "부족" : "충족")
                .font(FINDRFont.bold(11))
                .foregroundStyle(isMissing ? FINDRColor.danger : FINDRColor.success)
        }
        .frame(minHeight: 38)
    }

    private func benefitTag(icon: String, title: String) -> some View {
        HStack(spacing: 6) {
            FINDRIcon(name: icon, size: 16, tint: FINDRColor.brand)
            Text(title)
                .font(FINDRFont.medium(13))
                .kerning(-0.26)
                .foregroundStyle(FINDRColor.primaryText)
        }
        .padding(.horizontal, 12)
        .frame(height: 38)
        .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var unlockCallout: some View {
        Button(action: onPrepareWithPath) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(FINDRColor.primaryText.opacity(0.12)).frame(width: 36, height: 36)
                    FINDRIcon(name: FINDRAssetName.unlock, size: 18, tint: FINDRColor.inverseSecondary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("포트폴리오를 준비하면")
                        .font(FINDRFont.regular(11))
                        .foregroundStyle(FINDRColor.inverseSecondary)
                    Text("새롭게 6개의 기회가 열려요")
                        .font(FINDRFont.bold(14))
                        .foregroundStyle(.white)
                }
                Spacer()
                FINDRIcon(name: FINDRAssetName.arrowRight, size: 20, tint: .white)
            }
            .padding(14)
            .background(FINDRColor.inverse, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var bottomActions: some View {
        HStack(spacing: 10) {
            FINDRButton(title: isSaved ? "저장됨" : "저장하기", kind: .outline) {
                toggleSaved()
            }
            .frame(height: 55)
            .frame(maxWidth: 116)
            FINDRButton(title: isMissing ? "A-Path에서 준비하기" : "신청하러 가기", kind: isMissing ? .primary : .inverse) {
                if isMissing { onPrepareWithPath() } else { showApplyNotice = true }
            }
            .frame(height: 53)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 13)
        .padding(.bottom, -4)
        .background(FINDRColor.surface.overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }.ignoresSafeArea(edges: .bottom))
    }

    private func toggleSaved() {
        if isSaved { savedIDs.remove(opportunity.id) }
        else { savedIDs.insert(opportunity.id) }
    }
}
