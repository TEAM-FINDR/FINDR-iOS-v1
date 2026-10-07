import SwiftUI

struct FINDROnboardingResultCTAView: View {
    let action: () -> Void

    var body: some View {
        FINDRBottomCTA(title: "홈으로 가기", action: action)
    }
}
