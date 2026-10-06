import SwiftUI

struct FINDRProfileSetupFooterView: View {
    let page: Int
    let canContinue: Bool
    let action: () -> Void

    var body: some View {
        FINDRButton(title: page == 4 ? "분석 시작하기" : "다음", action: action)
            .disabled(!canContinue)
            .opacity(canContinue ? 1 : 0.5)
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, FINDRSpacing.medium)
            .padding(.bottom, 16)
    }
}
