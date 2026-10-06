import SwiftUI

struct ContentView: View {
    @AppStorage("FINDR.isDarkMode") private var isDarkMode = false
    @AppStorage("FINDR.didCompleteOnboarding") private var didCompleteOnboarding = false
    @AppStorage("FINDR.aPath.completedActionIDs") private var completedAPathActionIDsStorage = ""
    @State private var selectedTab: FINDRTab = .home
    @State private var navigationPath: [FINDRNavigationDestination] = []
    @State private var profile = FINDRProfileStore.load()
    @State private var notifications = FINDRNotification.samples
    @State private var savedIDs: Set<String> = [
        "app-dev-hackathon", "gwangju-ai-camp", "youth-startup-contest", "ai-sw-program", "design-bootcamp"
    ]

    var body: some View {
        Group {
            if didCompleteOnboarding {
                mainExperience
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                OnboardingFlowView(profile: $profile) {
                    FINDRProfileStore.save(profile)
                    didCompleteOnboarding = true
                }
            }
        }
    }

    private var mainExperience: some View {
        NavigationStack(path: $navigationPath) {
            selectedScreen
                .navigationDestination(for: FINDRNavigationDestination.self) { destination in
                    switch destination {
                    case .opportunity(let opportunity):
                        OpportunityDetailView(opportunity: opportunity, savedIDs: $savedIDs) {
                            selectedTab = .path
                            navigationPath.removeAll()
                        }
                    case .aPathSimulator:
                        APathSimulatorView(
                            completedActions: completedAPathActions,
                            onStartPortfolio: { openAPathAction(.portfolio) }
                        )
                    case .aPathAction(let actionID):
                        APathActionDetailView(
                            actionID: actionID,
                            isCompleted: completedAPathActions.contains(actionID),
                            onComplete: { completeAPathAction(actionID) }
                        )
                    case .aPathUnlocked(let actionID):
                        APathUnlockView(
                            actionID: actionID,
                            onOpenOpportunity: open,
                            onGoHome: {
                                selectedTab = .home
                                navigationPath.removeAll()
                            },
                            onViewOpportunities: {
                                selectedTab = .explore
                                navigationPath.removeAll()
                            }
                        )
                    case .notifications:
                        NotificationCenterView(
                            notifications: $notifications,
                            onOpenSettings: openNotificationSettings,
                            onSelectDestination: openNotificationDestination
                        )
                    case .notificationSettings:
                        NotificationSettingsView()
                    }
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if navigationPath.isEmpty {
                FINDRTabBar(selection: $selectedTab)
            }
        }
        .background(FINDRColor.canvas)
    }

    @ViewBuilder
    private var selectedScreen: some View {
        switch selectedTab {
        case .home:
            HomeView(
                onOpenOpportunity: open,
                onSeeAll: { selectedTab = .explore },
                onOpenNotifications: openNotificationCenter
            )
        case .explore:
            ExploreView(onOpenOpportunity: open, onOpenNotifications: openNotificationCenter)
        case .path:
            APathView(
                completedActions: completedAPathActions,
                onOpenSimulator: { navigationPath.append(.aPathSimulator) },
                onOpenAction: openAPathAction
            )
        case .saved:
            SavedView(
                savedIDs: $savedIDs,
                onOpenOpportunity: open,
                onOpenNotifications: openNotificationCenter
            )
        case .my:
            MyView(
                isDarkMode: $isDarkMode,
                profile: $profile,
                completedAPathActions: completedAPathActions,
                onOpenNotificationSettings: openNotificationSettings
            )
        }
    }

    private func open(_ opportunity: Opportunity) {
        navigationPath.append(.opportunity(opportunity))
    }

    private func openNotificationCenter() {
        navigationPath.append(.notifications)
    }

    private var completedAPathActions: Set<APathActionID> {
        Set(
            completedAPathActionIDsStorage
                .split(separator: ",")
                .compactMap { APathActionID(rawValue: String($0)) }
        )
    }

    private func openAPathAction(_ actionID: APathActionID) {
        navigationPath.append(.aPathAction(actionID))
    }

    private func completeAPathAction(_ actionID: APathActionID) {
        var completedActions = completedAPathActions
        completedActions.insert(actionID)
        completedAPathActionIDsStorage = completedActions
            .map(\.rawValue)
            .sorted()
            .joined(separator: ",")

        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        navigationPath.append(.aPathUnlocked(actionID))
    }

    private func openNotificationSettings() {
        navigationPath.append(.notificationSettings)
    }

    private func openNotificationDestination(_ destination: FINDRNotificationDestination) {
        switch destination {
        case .opportunity(let id):
            guard let opportunity = Opportunity.samples.first(where: { $0.id == id }) else { return }
            open(opportunity)
        case .tab(let tab):
            selectedTab = tab
            navigationPath.removeAll()
        }
    }
}

#Preview {
    ContentView()
}
