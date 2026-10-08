import SwiftUI
import UIKit

struct OpportunityDetailView: View {
    let opportunity: Opportunity
    @Binding var savedIDs: Set<String>
    let onOpenSaved: () -> Void
    let onOpenOpportunity: (Opportunity) -> Void
    let onOpenActions: (Opportunity) -> Void
    let onViewSimilarOpportunities: () -> Void
    let onPrepareWithPath: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var selectedSection = "상세 정보"
    @State private var showExternalSiteDialog = false
    @State private var showLinkUnavailableAlert = false
    @State private var isShareSheetPresented = false
    @State private var showContactUnavailableAlert = false
    @State private var showClosedReminderUnavailableAlert = false
    @State private var isSaveToastPresented = false

    private let sections = ["상세 정보", "지원 자격", "문의처"]
    private var isSaved: Bool { savedIDs.contains(opportunity.id) }
    private var isMissing: Bool { opportunity.status == .missing }
    private var usesEligibilityInfoCards: Bool { !opportunity.eligibilityInfoCards.isEmpty }
    private var usesContactInfo: Bool { opportunity.contactInfo != nil }
    private var usesContactSectionSpacing: Bool { usesContactInfo && selectedSection == "문의처" }
    private var usesExpandedDetailSpacing: Bool {
        usesContactSectionSpacing || (usesEligibilityInfoCards && selectedSection == "상세 정보")
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                navigationHeader
                    .padding(.bottom, 12)
                overview
                sectionSelector
                    .padding(.top, usesExpandedDetailSpacing ? 19 : (usesEligibilityInfoCards ? 10 : 15))
                sectionContent
                    .padding(.top, usesExpandedDetailSpacing ? 13 : (usesEligibilityInfoCards ? 12 : 17))
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
        .background(FINDRColor.surface)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomActions }
        .overlay(alignment: .bottom) {
            if isSaveToastPresented {
                saveToast
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.bottom, 76)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .overlay {
            if showExternalSiteDialog {
                externalSiteDialog
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .overlay {
            if isShareSheetPresented {
                FINDROpportunityShareSheetOverlay(
                    opportunity: opportunity,
                    onDismiss: { isShareSheetPresented = false },
                    onCopyLink: copyShareLink
                )
                .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSaveToastPresented)
        .animation(.easeInOut(duration: 0.2), value: showExternalSiteDialog)
        .animation(.easeInOut(duration: 0.2), value: isShareSheetPresented)
        .toolbar(.hidden, for: .navigationBar)
        .alert("연결된 링크가 없어요", isPresented: $showLinkUnavailableAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("현재 공고에는 신청 또는 공유 URL이 등록되지 않았어요. 기관의 공식 채널에서 확인해 주세요.")
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
            Button(action: toggleSaved) {
                FINDRIcon(
                    name: isSaved ? FINDRAssetName.savedBookmark : FINDRAssetName.bookmark,
                    size: 22,
                    tint: isSaved ? FINDRColor.brand : FINDRColor.primaryText,
                    usesTemplate: !isSaved
                )
                .frame(width: 24, height: 32)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isSaved ? "저장 취소" : "저장")
            Button {
                isShareSheetPresented = true
            } label: {
                FINDRIcon(name: FINDRAssetName.share, size: 22, tint: FINDRColor.primaryText)
                    .frame(width: 24, height: 32)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("공유하기")
            .padding(.leading, 14)
        }
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 0) {
            if opportunity.isClosed {
                Text("모집 마감")
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            } else {
                FINDRTag(title: opportunity.deadline, tone: opportunity.isUrgentDeadline ? .danger : .brand, font: FINDRFont.bold(12), kerning: 0, textHeight: 17, horizontalPadding: 8, verticalPadding: 4)
            }
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
                if let dateRange = opportunity.dateRange, !dateRange.isEmpty {
                    HStack(spacing: 6) {
                        FINDRIcon(name: FINDRAssetName.calendar, size: 16, tint: FINDRColor.tertiaryText)
                        Text(dateRange)
                            .font(FINDRFont.regular(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.secondaryText)
                    }
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
            if opportunity.eligibilityInfoCards.isEmpty {
                eligibilitySection
            } else {
                eligibilityInformationSection
            }
        case "문의처":
            if let contactInfo = opportunity.contactInfo {
                contactInformationSection(contactInfo)
            } else {
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
            }
        default:
            if opportunity.isClosed {
                closedOpportunitySection
            } else {
                eligibilitySection
            }
        }
    }

    private var closedOpportunitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("모집이 마감되었어요")
                    .font(FINDRFont.bold(15))
                    .kerning(-0.3)
                    .foregroundStyle(FINDRColor.secondaryText)
                Text("다음 모집이 열리면 알려드릴까요?")
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.tertiaryText)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text("비슷한 기회")
                .font(FINDRFont.bold(17))
                .kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText)

            VStack(spacing: 14) {
                ForEach(Opportunity.closedOpportunityRecommendations) { recommendation in
                    OpportunityListRow(
                        opportunity: recommendation,
                        showsProgress: false,
                        showsDivider: false,
                        rowHeight: 88,
                        informationSpacing: 2,
                        trailingSpacing: 20,
                        artworkCornerRadius: 12,
                        moreIconName: FINDRAssetName.aPathMore,
                        onMore: { onOpenActions(recommendation) },
                        onTap: { onOpenOpportunity(recommendation) }
                    )
                }
            }
        }
    }

    private func contactInformationSection(_ info: OpportunityContactInfo) -> some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(FINDRColor.brandSubtle)
                        .frame(width: 44, height: 44)
                    FINDRIcon(name: FINDRAssetName.detailContactBuilding, size: 22, usesTemplate: false)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(opportunity.organization)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                    Text("\(info.department) · \(info.officeHours)")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                }
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(spacing: 0) {
                ForEach(info.items) { item in
                    Button {
                        showContactUnavailableAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            FINDRIcon(name: item.kind.iconName, size: 20, usesTemplate: false)
                            Text(item.title)
                                .font(FINDRFont.medium(14))
                                .kerning(-0.28)
                                .foregroundStyle(FINDRColor.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            FINDRIcon(name: FINDRAssetName.detailContactChevron, size: 16, usesTemplate: false)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
        }
        .alert("연락처 링크", isPresented: $showContactUnavailableAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("현재 공고에 연락처 또는 원문 URL이 등록되지 않아 열 수 없어요. 기관의 공식 채널에서 확인해 주세요.")
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
            if !isMissing {
                HStack(spacing: 8) {
                    benefitTag(icon: FINDRAssetName.gift, title: "교육비 무료")
                    benefitTag(icon: FINDRAssetName.detailCertificateAward, title: "수료증 제공")
                }
            }
            if isMissing {
                unlockCallout
                    .padding(.top, 2)
            }
        }
    }

    private var eligibilityInformationSection: some View {
        VStack(spacing: 12) {
            ForEach(opportunity.eligibilityInfoCards) { card in
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.title)
                        .font(FINDRFont.bold(14))
                        .kerning(-0.28)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(height: 19.32, alignment: .top)

                    ForEach(card.bulletItems, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("·")
                                .font(FINDRFont.regular(13))
                                .kerning(-0.26)
                                .foregroundStyle(FINDRColor.tertiaryText)
                                .frame(height: 18.2, alignment: .top)

                            Text(item)
                                .font(FINDRFont.regular(13))
                                .kerning(-0.26)
                                .foregroundStyle(FINDRColor.secondaryText)
                                .lineLimit(1)
                                .frame(height: 18.2, alignment: .top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var statusCard: some View {
        let isEligible = !isMissing && opportunity.progress >= 1
        let title = isEligible ? "지금, 이 기회에 지원할 수 있어요!" : (opportunity.status == .nearlyEligible ? "조금만 더 준비하면 지원 가능해요" : "포트폴리오만 준비하면 지원 가능해요")
        let tone = isEligible ? FINDRTagTone.success : (opportunity.status == .nearlyEligible ? FINDRTagTone.warning : .warning)
        let iconName = isEligible ? FINDRAssetName.checkCircle : FINDRAssetName.alert
        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(FINDRColor.surface).frame(width: 36, height: 36)
                    FINDRIcon(name: iconName, size: 22, tint: tone.foreground, usesTemplate: !isEligible)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(isEligible ? FINDRColor.successStrong : tone.foreground)
                    Text("\(opportunity.completedConditions)/\(opportunity.totalConditions) 조건 충족 · \(Int(opportunity.progress * 100))%")
                        .font(FINDRFont.medium(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                }
            }
            FINDRProgressBar(progress: opportunity.progress, color: isEligible ? FINDRColor.successStatus : FINDRColor.warningStatus, height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
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
        .background(FINDRColor.canvas, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var unlockCallout: some View {
        Button(action: onPrepareWithPath) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(FINDRColor.primaryText.opacity(0.12)).frame(width: 36, height: 36)
                    FINDRIcon(name: FINDRAssetName.unlock, size: 22, tint: FINDRColor.inverseSecondary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("포트폴리오를 준비하면")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.inverseSecondary)
                    (Text("새롭게 ").foregroundColor(.white)
                        + Text("6개").foregroundColor(Color(hex: 0x7FA6FF))
                        + Text("의 기회가 열려요").foregroundColor(.white))
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                }
                Spacer()
                FINDRIcon(name: FINDRAssetName.arrowRight, size: 20, tint: .white)
            }
            .padding(16)
            .background(FINDRColor.inverse, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var bottomActions: some View {
        VStack(spacing: 18) {
            HStack(spacing: 10) {
                if opportunity.isClosed {
                    FINDRButton(title: "알림 받기", kind: .outline) {
                        showClosedReminderUnavailableAlert = true
                    }
                    .frame(height: 55)
                    .frame(maxWidth: 116)
                    .alert("모집 알림", isPresented: $showClosedReminderUnavailableAlert) {
                        Button("확인", role: .cancel) {}
                    } message: {
                        Text("모집 정보가 업데이트될 때 알림을 보내는 기능은 아직 연결되지 않았어요.")
                    }

                    FINDRButton(title: "비슷한 기회 보기", kind: .accent) {
                        onViewSimilarOpportunities()
                    }
                    .frame(height: 53)
                } else {
                    FINDRButton(title: "저장하기", kind: .outline) {
                        saveOpportunity()
                    }
                    .frame(height: 55)
                    .frame(maxWidth: 116)
                    FINDRButton(title: isMissing ? "A-Path에서 준비하기" : "신청하러 가기", kind: isMissing ? .primary : .inverse) {
                        if isMissing { onPrepareWithPath() } else { showExternalSiteDialog = true }
                    }
                    .frame(height: 53)
                }
            }
            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(FINDRColor.surface.overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }.ignoresSafeArea(edges: .bottom))
        .ignoresSafeArea(edges: .bottom)
    }

    private var externalSiteDialog: some View {
        ZStack {
            Button {
                showExternalSiteDialog = false
            } label: {
                FINDRColor.scrim.opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("외부 사이트 안내 닫기")

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(FINDRColor.brandSubtle)
                        .frame(width: 48, height: 48)
                    FINDRIcon(name: FINDRAssetName.externalSiteGlobe, size: 24, usesTemplate: false)
                }

                VStack(spacing: 4) {
                    Text("외부 사이트로 이동해요")
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(maxWidth: .infinity)

                    Text("\(opportunity.organization) 신청 페이지에서 지원을 완료해주\u{200B}세요. 지원 여부는 A에 자동 반영되지 않아요.")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                }

                HStack(spacing: 8) {
                    FINDRButton(title: "취소", kind: .outline, height: 53) {
                        showExternalSiteDialog = false
                    }
                    FINDRButton(title: "이동하기", kind: .accent, height: 53) {
                        openApplicationPage()
                    }
                }
            }
            .padding(24)
            .frame(width: 320)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
            .accessibilityElement(children: .contain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    private func openApplicationPage() {
        showExternalSiteDialog = false
        guard let applicationURL = opportunity.applicationURL else {
            showLinkUnavailableAlert = true
            return
        }
        openURL(applicationURL)
    }

    private func copyShareLink(_ shareURL: URL?) {
        isShareSheetPresented = false
        guard let shareURL else {
            showLinkUnavailableAlert = true
            return
        }
        UIPasteboard.general.url = shareURL
    }

    private func toggleSaved() {
        if isSaved {
            savedIDs.remove(opportunity.id)
            withAnimation(.easeInOut(duration: 0.2)) { isSaveToastPresented = false }
        } else {
            saveOpportunity()
        }
    }

    private func saveOpportunity() {
        savedIDs.insert(opportunity.id)
        guard !isSaveToastPresented else { return }
        withAnimation(.easeInOut(duration: 0.2)) { isSaveToastPresented = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.2)) { isSaveToastPresented = false }
        }
    }

    private var saveToast: some View {
        Button(action: onOpenSaved) {
            HStack(spacing: 8) {
                FINDRIcon(name: FINDRAssetName.saveToastCheck, size: 20, usesTemplate: false)
                Text("저장했어요 · 마감 3일 전에 알려드릴게요")
                    .font(FINDRFont.medium(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.surface)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("보기")
                    .font(FINDRFont.bold(13))
                    .kerning(-0.26)
                    .foregroundStyle(Color(hex: 0x7FA6FF))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FINDRColor.inverse, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("저장 목록 보기")
    }
}
