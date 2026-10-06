import SwiftUI

struct FINDROnboardingResultInsightView: View {
    var body: some View {
        Text("A-Path에서 무엇을 하면 더 많은 기회가 열리는지 확인해보세요.")
            .font(FINDRFont.regular(13))
            .tracking(-0.26)
            .foregroundStyle(FINDRColor.tertiaryText)
            .fixedSize(horizontal: false, vertical: true)
    }
}
