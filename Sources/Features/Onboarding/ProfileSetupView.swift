import SwiftUI

struct FINDRProfileSetupView: View {
    let page: Int
    @Binding var profile: FINDROnboardingProfile
    let onBack: () -> Void
    let onContinue: () -> Void

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
            FINDRProfileSetupStatusSelectionView(status: $profile.status)
        case 3:
            FINDRProfileSetupInterestsView(selection: $profile.interests)
        case 4:
            FINDRProfileSetupOpportunityTypesView(selection: $profile.opportunityTypes)
        default:
            FINDRProfileSetupPersonalInformationView(
                birthYear: $profile.birthYear,
                region: $profile.region
            )
        }
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
