import SwiftUI

struct FINDROnboardingResultView: View {
    let profile: FINDROnboardingProfile
    let onLater: () -> Void
    let onRequestNotifications: () -> Void

    @State private var isPermissionPromptVisible = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        FINDROnboardingResultHeaderView(profile: profile)
                        FINDROnboardingResultMetricsCardView()
                        FINDROnboardingResultInsightView()
                    }
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.top, FINDRSpacing.xLarge)
                    .padding(.bottom, FINDRSpacing.large)
                }

                FINDROnboardingResultCTAView {
                    isPermissionPromptVisible = true
                }
            }

            if isPermissionPromptVisible {
                FINDRNotificationPermissionPromptView(
                    onLater: onLater,
                    onRequestNotifications: onRequestNotifications
                )
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: isPermissionPromptVisible)
    }
}
