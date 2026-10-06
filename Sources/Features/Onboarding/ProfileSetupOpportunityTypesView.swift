import SwiftUI

struct FINDRProfileSetupOpportunityTypesView: View {
    @Binding var selection: Set<String>

    private let options = FINDROnboardingProfileOptions.opportunityTypes

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
                ForEach(options, id: \.self) { option in
                    FINDRPill(title: option, isSelected: selection.contains(option)) {
                        toggle(option)
                    }
                }
            }

            Text("\(selection.count)개 선택됨")
                .font(FINDRFont.medium(12))
                .foregroundStyle(FINDRColor.brand)
                .accessibilityLabel("관심 기회 종류 \(selection.count)개 선택됨")
        }
    }

    private func toggle(_ option: String) {
        if selection.contains(option) {
            selection.remove(option)
        } else {
            selection.insert(option)
        }
    }
}
