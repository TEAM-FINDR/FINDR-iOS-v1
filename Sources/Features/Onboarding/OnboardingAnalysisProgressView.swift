import SwiftUI

struct FINDROnboardingAnalysisProgressView: View {
    var body: some View {
        FINDRProgressBar(progress: 0.7, color: FINDRColor.brandButton, height: 8)
            .frame(width: 260)
    }
}
