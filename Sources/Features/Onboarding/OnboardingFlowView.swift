import SwiftUI
import UserNotifications

struct OnboardingFlowView: View {
    @Binding var profile: FINDROnboardingProfile
    let onComplete: () -> Void

    @State private var step: FINDROnboardingFlowStep = .splash

    var body: some View {
        Group {
            switch step {
            case .splash:
                FINDRSplashView()
            case .introduction(let page):
                FINDROnboardingIntroView(
                    page: page,
                    onSkip: { step = .login },
                    onContinue: { step = step.advancingIntroduction() }
                )
            case .login:
                FINDROnboardingLoginView {
                    step = .profile(1)
                }
            case .profile(let page):
                FINDRProfileSetupView(
                    page: page,
                    profile: $profile,
                    onBack: { step = step.goingBackFromProfile() },
                    onContinue: { step = step.advancingProfile() }
                )
            case .analyzing:
                FINDRAnalyzingView()
            case .result:
                FINDROnboardingResultView(
                    profile: profile,
                    onLater: onComplete,
                    onRequestNotifications: requestNotificationPermission
                )
            }
        }
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(step == .splash ? .dark : .light)
        .task(id: step) {
            switch step {
            case .splash:
                try? await Task.sleep(for: .milliseconds(900))
                guard !Task.isCancelled else { return }
                step = .introduction(1)
            case .analyzing:
                try? await Task.sleep(for: .milliseconds(1_200))
                guard !Task.isCancelled else { return }
                step = .result
            case .introduction, .login, .profile, .result:
                break
            }
        }
        .animation(.easeInOut(duration: 0.2), value: step)
    }

    private func requestNotificationPermission() {
        Task {
            _ = try? await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            onComplete()
        }
    }
}
