import SwiftUI

struct FINDRProfileSetupFooterView: View {
    let page: Int
    let canContinue: Bool
    let action: () -> Void

    var body: some View {
        FINDRBottomCTA(
            title: page == 4 ? "분석 시작하기" : "다음",
            buttonKind: .accent,
            isEnabled: canContinue,
            action: action
        )
    }
}
