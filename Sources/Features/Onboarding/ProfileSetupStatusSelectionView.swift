import SwiftUI

struct FINDRProfileSetupStatusSelectionView: View {
    @Binding var status: String

    private let options = ["중학생", "고등학생", "대학생", "취업 준비", "직장인", "기타"]

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
