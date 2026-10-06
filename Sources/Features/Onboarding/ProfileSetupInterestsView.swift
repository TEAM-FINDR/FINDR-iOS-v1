import SwiftUI

struct FINDRProfileSetupInterestsView: View {
    @Binding var selection: Set<String>

    private let options = [
        "개발", "디자인", "AI·데이터", "마케팅", "영상·미디어", "과학",
        "환경", "사회공헌", "금융", "글쓰기", "음악·예술", "창업"
    ]

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
                .accessibilityLabel("관심 분야 \(selection.count)개 선택됨")
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
