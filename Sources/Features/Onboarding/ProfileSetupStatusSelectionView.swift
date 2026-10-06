import SwiftUI

struct FINDRProfileSetupStatusSelectionView: View {
    @Binding var status: String

    private let options = FINDROnboardingProfileOptions.statuses

    var body: some View {
        VStack(spacing: FINDRSpacing.small) {
            ForEach(options, id: \.self) { option in
                FINDRProfileStatusOptionRowView(
                    title: option,
                    isSelected: status == option
                ) {
                    status = option
                }
            }
        }
        .accessibilityLabel("현재 상태 선택")
    }
}
