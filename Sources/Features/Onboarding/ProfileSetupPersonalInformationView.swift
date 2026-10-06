import SwiftUI

struct FINDRProfileSetupPersonalInformationView: View {
    @Binding var birthYear: String
    @Binding var region: String

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            FINDRProfileSetupInputFieldView(
                title: "출생연도",
                helper: "만 나이 계산에만 사용돼요",
                text: $birthYear,
                keyboard: .numberPad
            )

            FINDRProfileSetupInputFieldView(
                title: "거주 지역",
                helper: "지역 조건이 있는 기회에 사용돼요",
                text: $region,
                isAccent: true
            )
        }
    }
}
