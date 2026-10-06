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
                VStack(alignment: .leading, spacing: FINDRSpacing.section) {
                    FINDRProfileSetupTitleView(
                        title: "관심 분야를\n선택해주세요",
                        subtitle: "관심 분야는 최대 5개까지 선택할 수 있어요."
                    )
                    interestSection
                    opportunityTypeSection
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.medium)
                .padding(.bottom, FINDRSpacing.large)
            }
        }
        .background(FINDRColor.canvas.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            FINDRButton(title: "저장", action: save)
                .disabled(draft.interests.isEmpty || draft.opportunityTypes.isEmpty)
                .opacity(draft.interests.isEmpty || draft.opportunityTypes.isEmpty ? 0.45 : 1)
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
                .padding(.bottom, FINDRSpacing.small)
                .background(FINDRColor.canvas)
        }
    }

    private var interestSection: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            HStack {
                Text("관심 분야")
                    .font(FINDRFont.bold(15))
                    .foregroundStyle(FINDRColor.primaryText)
                Spacer()
                Text("\(draft.interests.count)/5")
                    .font(FINDRFont.medium(12))
                    .foregroundStyle(FINDRColor.brand)
                    .accessibilityLabel("관심 분야 \(draft.interests.count)개, 최대 5개")
            }
            FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
                ForEach(FINDROnboardingProfileOptions.interests, id: \.self) { interest in
                    FINDRPill(title: interest, isSelected: draft.interests.contains(interest)) {
                        draft.toggleInterest(interest)
                    }
                }
            }
        }
        .padding(FINDRSpacing.large)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
    }

    private var opportunityTypeSection: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            Text("관심 기회 종류")
                .font(FINDRFont.bold(15))
                .foregroundStyle(FINDRColor.primaryText)
            FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
                ForEach(FINDROnboardingProfileOptions.opportunityTypes, id: \.self) { type in
                    FINDRPill(title: type, isSelected: draft.opportunityTypes.contains(type)) {
                        toggleOpportunityType(type)
                    }
                }
            }
            Text("선택한 종류를 우선 추천해드려요")
                .font(FINDRFont.regular(11))
                .foregroundStyle(FINDRColor.tertiaryText)
        }
        .padding(FINDRSpacing.large)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
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
