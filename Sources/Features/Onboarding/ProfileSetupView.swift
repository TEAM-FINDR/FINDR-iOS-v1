import SwiftUI

struct FINDROnboardingProfile {
    var birthYear = "2009"
    var region = "광주광역시"
    var status = "고등학생"
    var interests: Set<String> = ["개발", "디자인", "창업"]
    var opportunityTypes: Set<String> = ["교육", "공모전", "창업"]

    var age: Int {
        let currentYear = Calendar.current.component(.year, from: .now)
        return max(0, currentYear - (Int(birthYear) ?? currentYear))
    }

    var orderedInterests: [String] {
        FINDRProfileSetupView.interestOptions.filter(interests.contains)
    }
}

struct FINDRProfileSetupView: View {
    let page: Int
    @Binding var profile: FINDROnboardingProfile
    let onBack: () -> Void
    let onContinue: () -> Void

    static let interestOptions = FINDROnboardingProfileOptions.interests

    var body: some View {
        VStack(spacing: 0) {
            FINDRProfileSetupNavigationBarView(onBack: onBack)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                    FINDRProfileSetupProgressView(page: page)
                    FINDRProfileSetupTitleView(title: title, subtitle: subtitle)
                    pageContent
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.medium)
                .padding(.bottom, FINDRSpacing.large)
            }
            .scrollDismissesKeyboard(.interactively)

            FINDRProfileSetupFooterView(page: page, canContinue: canContinue, action: continueIfValid)
        }
        .background(Color.white.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.15), value: page)
    }

    @ViewBuilder
    private var pageContent: some View {
        switch page {
        case 2:
            statusChoices
        case 3:
            interestChoices
        case 4:
            opportunityChoices
        default:
            FINDRProfileSetupPersonalInformationView(
                birthYear: $profile.birthYear,
                region: $profile.region
            )
        }
    }

    private var statusChoices: some View {
        FINDRProfileSetupStatusSelectionView(status: $profile.status)
    }

    private var interestChoices: some View {
        FINDRProfileSetupInterestsView(selection: $profile.interests)
    }

    private var opportunityChoices: some View {
        FINDRProfileSetupOpportunityTypesView(selection: $profile.opportunityTypes)
    }

    private var title: String {
        switch page {
        case 2: "현재 상태를\n선택해주세요"
        case 3: "관심 분야를\n골라주세요"
        case 4: "어떤 기회를\n찾고 있나요?"
        default: "출생연도와 지역을\n알려주세요"
        }
    }

    private var subtitle: String? {
        switch page {
        case 1: "지원 가능한 기회를 계산하는 데만 사용돼요."
        case 3: "여러 개 선택할 수 있어요."
        case 4: "관심 있는 종류를 우선 추천해드려요."
        default: nil
        }
    }

    private var canContinue: Bool {
        switch page {
        case 1:
            guard let year = Int(profile.birthYear) else { return false }
            let currentYear = Calendar.current.component(.year, from: .now)
            return (1900...currentYear).contains(year) && !profile.region.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 3:
            return !profile.interests.isEmpty
        case 4:
            return !profile.opportunityTypes.isEmpty
        default:
            return !profile.status.isEmpty
        }
    }

    private func continueIfValid() {
        guard canContinue else { return }
        onContinue()
    }

}

private struct FINDRChipFlowLayout: Layout {
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? subviews.reduce(CGFloat.zero) { $0 + $1.sizeThatFits(.unspecified).width + horizontalSpacing }
        let frames = itemFrames(width: width, subviews: subviews)
        let contentHeight = frames.map(\.maxY).max() ?? 0
        return CGSize(width: proposal.width ?? width, height: contentHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = itemFrames(width: bounds.width, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let frame = frames[index]
            subview.place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                anchor: .topLeading,
                proposal: ProposedViewSize(width: frame.width, height: frame.height)
            )
        }
    }

    private func itemFrames(width: CGFloat, subviews: Subviews) -> [CGRect] {
        var frames: [CGRect] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > width {
                x = 0
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }

        return frames
    }
}
