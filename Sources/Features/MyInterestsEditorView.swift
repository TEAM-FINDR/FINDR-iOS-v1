import SwiftUI

struct MyInterestsEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var profile: FINDROnboardingProfile
    let onSave: () -> Void

    @State private var draft: FINDROnboardingProfile

    init(profile: Binding<FINDROnboardingProfile>, onSave: @escaping () -> Void) {
        _profile = profile
        _draft = State(initialValue: profile.wrappedValue)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "관심 분야", onBack: { dismiss() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
                    Text("관심 분야")
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(height: 24, alignment: .leading)
                    Text("최대 5개까지 선택할 수 있어요.")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .frame(height: 18, alignment: .leading)
                    interestSection
                    Color.clear.frame(height: FINDRSpacing.medium)
                    Text("관심 있는 기회 종류")
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(height: 24, alignment: .leading)
                    opportunityTypeSection
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
                .padding(.bottom, FINDRSpacing.large)
            }
        }
        .background(FINDRColor.surface.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            FINDRBottomCTA(
                title: "저장하기",
                isEnabled: !draft.interests.isEmpty && !draft.opportunityTypes.isEmpty,
                action: save
            )
        }
    }

    private var interestSection: some View {
        FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
            ForEach(FINDROnboardingProfileOptions.myProfileInterests, id: \.self) { interest in
                FINDRPill(title: interest, isSelected: draft.interests.contains(interest)) {
                    draft.toggleInterest(interest)
                }
            }
        }
    }

    private var opportunityTypeSection: some View {
        FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
            ForEach(FINDROnboardingProfileOptions.opportunityTypes, id: \.self) { type in
                FINDRPill(title: type, isSelected: draft.opportunityTypes.contains(type)) {
                    toggleOpportunityType(type)
                }
            }
        }
    }

    private func toggleOpportunityType(_ type: String) {
        if draft.opportunityTypes.contains(type) {
            draft.opportunityTypes.remove(type)
        } else {
            draft.opportunityTypes.insert(type)
        }
    }

    private func save() {
        guard !draft.interests.isEmpty, draft.interests.count <= 5, !draft.opportunityTypes.isEmpty else { return }
        profile = draft
        FINDRProfileStore.save(draft)
        onSave()
        dismiss()
    }
}
