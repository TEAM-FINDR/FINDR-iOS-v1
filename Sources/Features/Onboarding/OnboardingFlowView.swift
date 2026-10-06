import SwiftUI
import UserNotifications

private enum OnboardingStep: Equatable {
    case splash
    case introduction(Int)
    case login
    case profile(Int)
    case analyzing
    case result
}

struct OnboardingFlowView: View {
    let onComplete: () -> Void

    @State private var step: OnboardingStep = .splash
    @State private var profile = FINDROnboardingProfile()

    var body: some View {
        Group {
            switch step {
            case .splash:
                FINDRSplashView()
            case .introduction(let page):
                FINDROnboardingIntroView(
                    page: page,
                    onSkip: { step = .login },
                    onContinue: advanceIntroduction
                )
            case .login:
                FINDROnboardingLoginView {
                    step = .profile(1)
                }
            case .profile(let page):
                FINDRProfileSetupView(
                    page: page,
                    profile: $profile,
                    onBack: goBackFromProfile,
                    onContinue: advanceProfile
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

    private func advanceIntroduction() {
        guard case .introduction(let page) = step else { return }
        step = page < 3 ? .introduction(page + 1) : .login
    }

    private func advanceProfile() {
        guard case .profile(let page) = step else { return }
        step = page < 4 ? .profile(page + 1) : .analyzing
    }

    private func goBackFromProfile() {
        guard case .profile(let page) = step else { return }
        step = page > 1 ? .profile(page - 1) : .login
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
