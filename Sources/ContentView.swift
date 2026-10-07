import SwiftUI

struct ContentView: View {
    @AppStorage("FINDR.isDarkMode") private var isDarkMode = false
    @AppStorage("FINDR.didCompleteOnboarding") private var didCompleteOnboarding = false
    @AppStorage("FINDR.aPath.completedActionIDs") private var completedAPathActionIDsStorage = ""
    @State private var selectedTab: FINDRTab = .home
    @State private var navigationPath: [FINDRNavigationDestination] = []
    @State private var exploreQuery = ""
    @State private var exploreFilterResetVersion = 0
    @State private var exploreFilters: [String: String] = [:]
    @State private var exploreFilterDraft = FINDRExploreFilterLogic.figmaSelections
    @State private var didOpenExploreFilterSheet = false
    @State private var isExploreFilterSheetPresented = false
    @State private var profile = FINDRProfileStore.load()
    @State private var isConditionSheetPresented = false
    @State private var notifications = FINDRNotification.samples
    @State private var savedIDs: Set<String> = [
        "app-dev-hackathon", "gwangju-ai-camp", "youth-startup-contest", "ai-sw-program", "design-bootcamp"
    ]

    var body: some View {
        appContent
    }

    private var appContent: some View {
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
                    case .recommendedOpportunities:
                        RecommendedOpportunitiesView(onOpenOpportunity: open)
                    case .search:
                        SearchView(query: $exploreQuery) {
                            navigationPath.append(.searchResults)
                        }
                    case .searchResults:
                        SearchResultsView(
                            query: $exploreQuery,
                            onOpenOpportunity: open,
                            onCancel: { navigationPath.removeAll() },
                            onClear: {
                                if !navigationPath.isEmpty {
                                    navigationPath.removeLast()
                                }
                            },
                            onResetFilters: {
                                exploreQuery = ""
                                exploreFilters = [:]
                                exploreFilterResetVersion += 1
                                navigationPath.removeAll()
                            }
                        )
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
        .overlay {
            if isConditionSheetPresented {
                conditionSheetOverlay
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .overlay {
            if isExploreFilterSheetPresented {
                FINDRExploreFilterSheetOverlay(
                    selections: exploreFilterDraft,
                    onDismiss: { isExploreFilterSheetPresented = false },
                    onApply: { selections in
                        exploreFilters = selections
                        isExploreFilterSheetPresented = false
                    }
                )
                .transition(.opacity)
                .zIndex(11)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isConditionSheetPresented)
        .animation(.easeInOut(duration: 0.2), value: isExploreFilterSheetPresented)
    }

    @ViewBuilder
    private var selectedScreen: some View {
        switch selectedTab {
        case .home:
            HomeView(
                onOpenOpportunity: open,
                onSeeAll: { navigationPath.append(.recommendedOpportunities) },
                onOpenNotifications: openNotificationCenter,
                onOpenNotificationSettings: openNotificationSettings,
                onOpenAPath: {
                    selectedTab = .path
                    navigationPath.removeAll()
                }
            )
        case .explore:
            ExploreView(
                query: $exploreQuery,
                filterResetVersion: $exploreFilterResetVersion,
                selectedFilters: $exploreFilters,
                onOpenOpportunity: open,
                onOpenNotifications: openNotificationCenter,
                onOpenSearch: { navigationPath.append(.search) },
                onOpenFilters: presentExploreFilterSheet
            )
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
                onOpenNotificationSettings: openNotificationSettings,
                onPresentConditionSheet: { isConditionSheetPresented = true }
            )
        }
    }

    private var conditionSheetOverlay: some View {
        FINDRConditionSheetOverlay(
            ownedConditions: ownedConditions,
            onDismiss: { isConditionSheetPresented = false },
            onAdd: { condition in
                profile.conditions.insert(condition)
                FINDRProfileStore.save(profile)
            }
        )
    }

    private var ownedConditions: Set<FINDRProfileCondition> {
        var values = profile.conditions
        if completedAPathActions.contains(.portfolio) {
            values.insert(.portfolio)
        }
        return values
    }

    private func open(_ opportunity: Opportunity) {
        navigationPath.append(.opportunity(opportunity))
    }

    private func openNotificationCenter() {
        navigationPath.append(.notifications)
    }

    private func presentExploreFilterSheet() {
        if didOpenExploreFilterSheet {
            exploreFilterDraft = FINDRExploreFilterLogic.allSelections.merging(exploreFilters) { _, applied in applied }
        } else {
            exploreFilterDraft = FINDRExploreFilterLogic.figmaSelections
            didOpenExploreFilterSheet = true
        }
        isExploreFilterSheetPresented = true
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
