import SwiftUI

struct ContentView: View {
    @AppStorage("FINDR.isDarkMode") private var isDarkMode = false
    @AppStorage("FINDR.didCompleteOnboarding") private var didCompleteOnboarding = false
    @AppStorage("FINDR.aPath.completedActionIDs") private var completedAPathActionIDsStorage = ""
    @AppStorage("FINDR.explore.ignoredOpportunityIDs") private var ignoredExploreOpportunityIDsStorage = ""
    @AppStorage("FINDR.isLoggedOut") private var isLoggedOut = false
    @State private var accountConfirmation: AccountConfirmation?
    @State private var withdrawalUnavailable = false
    @StateObject private var connectivity = FINDRConnectivity()
    @State private var selectedTab: FINDRTab = .home
    @State private var navigationPath: [FINDRNavigationDestination] = []
    @State private var exploreQuery = ""
    @State private var exploreFilterResetVersion = 0
    @State private var exploreFilters: [String: String] = [:]
    @State private var exploreFilterDraft = FINDRExploreFilterLogic.figmaSelections
    @State private var didOpenExploreFilterSheet = false
    @State private var isExploreFilterSheetPresented = false
    @State private var exploreSort: FINDRExploreSort = .recommended
    @State private var isExploreSortSheetPresented = false
    @State private var selectedOpportunityForActions: Opportunity?
    @State private var selectedSavedOpportunityForActions: Opportunity?
    @State private var savedRemovalCandidate: Opportunity?
    @State private var savedRemovalToastOpportunity: Opportunity?
    @State private var isReportUnavailableAlertPresented = false
    @State private var profile = FINDRProfileStore.load()
    @State private var isConditionSheetPresented = false
    @State private var isAPathHelpPresented = false
    @State private var notifications = FINDRNotification.samples
    @State private var savedIDs: Set<String> = [
        "app-dev-hackathon", "gwangju-ai-camp", "youth-startup-contest", "ai-sw-program", "design-bootcamp"
    ]

    var body: some View {
        ZStack {
            appContent
            if didCompleteOnboarding && !isLoggedOut && selectedTab == .home && navigationPath.isEmpty && connectivity.presentation == .toast {
                NetworkErrorToastOverlay(onRetry: connectivity.retry).zIndex(18)
            }
            if let kind = accountConfirmation {
                AccountConfirmationOverlay(kind: kind, onCancel: { accountConfirmation = nil }, onConfirm: {
                    accountConfirmation = nil
                    if kind == .logout { isLoggedOut = true; navigationPath.removeAll() } else { withdrawalUnavailable = true }
                }).zIndex(20)
            }
            if savedRemovalToastOpportunity != nil {
                SavedOpportunityRemovalToastOverlay(onUndo: undoSavedOpportunityRemoval)
                    .zIndex(17)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.2), value: savedRemovalToastOpportunity)
        .alert("회원 탈퇴 서비스 미연결", isPresented: $withdrawalUnavailable) { Button("확인", role: .cancel) {} } message: { Text("계정 삭제 서비스가 연결되어 있지 않아 탈퇴를 처리할 수 없어요.") }
    }

    private var appContent: some View {
        Group {
            if isLoggedOut {
                FINDROnboardingLoginView { isLoggedOut = false }
            } else if didCompleteOnboarding {
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
        GeometryReader { geometry in
        NavigationStack(path: $navigationPath) {
            selectedScreen
                .padding(.top, 48 - geometry.safeAreaInsets.top)
                .navigationDestination(for: FINDRNavigationDestination.self) { destination in
                    Group {
                    switch destination {
                    case .opportunity(let opportunity):
                        OpportunityDetailView(
                            opportunity: opportunity,
                            savedIDs: $savedIDs,
                            onOpenSaved: {
                                selectedTab = .saved
                                navigationPath.removeAll()
                            },
                            onOpenOpportunity: open,
                            onOpenActions: { selectedOpportunityForActions = $0 },
                            onViewSimilarOpportunities: {
                                selectedTab = .explore
                                navigationPath.removeAll()
                            },
                            onPrepareWithPath: {
                                selectedTab = .path
                                navigationPath.removeAll()
                            }
                        )
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
                    case .settings:
                        SettingsView(profile: $profile, onNotifications: openNotificationSettings,
                                     onHelp: { navigationPath.append(.help) },
                                     onLogout: { accountConfirmation = .logout }, onWithdraw: { accountConfirmation = .withdrawal })
                    case .activityHistory:
                        ActivityHistoryView()
                    case .help:
                        HelpView()
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
                    .padding(.top, 48 - geometry.safeAreaInsets.top)
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
        .overlay {
            if isExploreSortSheetPresented {
                FINDRExploreSortSheetOverlay(
                    selectedSort: exploreSort,
                    onDismiss: { isExploreSortSheetPresented = false },
                    onSelect: { sort in
                        exploreSort = sort
                        isExploreSortSheetPresented = false
                    }
                )
                .transition(.opacity)
                .zIndex(12)
            }
        }
        .overlay {
            if let opportunity = selectedOpportunityForActions {
                FINDROpportunityActionsSheetOverlay(
                    opportunity: opportunity,
                    onDismiss: { selectedOpportunityForActions = nil },
                    onSave: {
                        savedIDs.insert(opportunity.id)
                        selectedOpportunityForActions = nil
                    },
                    onIgnore: {
                        ignoreOpportunityInExplore(opportunity.id)
                        selectedOpportunityForActions = nil
                    },
                    onReport: {
                        selectedOpportunityForActions = nil
                        isReportUnavailableAlertPresented = true
                    }
                )
                .transition(.opacity)
                .zIndex(13)
            }
        }
        .overlay {
            if isAPathHelpPresented {
                APathHelpSheetOverlay(onDismiss: { isAPathHelpPresented = false })
                    .zIndex(14)
            }
        }
        .overlay {
            if let opportunity = selectedSavedOpportunityForActions {
                SavedOpportunityActionsSheetOverlay(
                    opportunity: opportunity,
                    onDismiss: { selectedSavedOpportunityForActions = nil },
                    onOpenReminderSettings: {
                        selectedSavedOpportunityForActions = nil
                        openNotificationSettings()
                    },
                    onRemove: {
                        selectedSavedOpportunityForActions = nil
                        savedRemovalCandidate = opportunity
                    }
                )
                .transition(.opacity)
                .zIndex(15)
            }
        }
        .overlay {
            if let opportunity = savedRemovalCandidate {
                SavedOpportunityRemovalConfirmationOverlay(
                    onCancel: { savedRemovalCandidate = nil },
                    onConfirm: {
                        savedIDs.remove(opportunity.id)
                        savedRemovalCandidate = nil
                        savedRemovalToastOpportunity = opportunity
                    }
                )
                .transition(.opacity)
                .zIndex(16)
            }
        }
        .alert("신고 기능", isPresented: $isReportUnavailableAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("신고 접수 기능이 아직 연결되지 않았어요.")
        }
        .animation(.easeInOut(duration: 0.2), value: isConditionSheetPresented)
        .animation(.easeInOut(duration: 0.2), value: isExploreFilterSheetPresented)
        .animation(.easeInOut(duration: 0.2), value: isExploreSortSheetPresented)
        .animation(.easeInOut(duration: 0.2), value: selectedOpportunityForActions)
        .animation(.easeInOut(duration: 0.2), value: selectedSavedOpportunityForActions)
        .animation(.easeInOut(duration: 0.2), value: savedRemovalCandidate)
        .animation(.easeInOut(duration: 0.2), value: isAPathHelpPresented)
        }
    }

    private func undoSavedOpportunityRemoval() {
        guard let opportunity = savedRemovalToastOpportunity else { return }
        savedIDs.insert(opportunity.id)
        savedRemovalToastOpportunity = nil
    }

    @ViewBuilder
    private var selectedScreen: some View {
        switch selectedTab {
        case .home:
            if connectivity.presentation == .fullScreen {
                NetworkErrorView(onRetry: connectivity.retry)
            } else {
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
            }
        case .explore:
            ExploreView(
                query: $exploreQuery,
                filterResetVersion: $exploreFilterResetVersion,
                selectedFilters: $exploreFilters,
                selectedSort: $exploreSort,
                ignoredOpportunityIDs: ignoredOpportunityIDsBinding,
                onOpenOpportunity: open,
                onOpenActions: { selectedOpportunityForActions = $0 },
                onOpenNotifications: openNotificationCenter,
                onOpenSearch: { navigationPath.append(.search) },
                onOpenFilters: presentExploreFilterSheet,
                onOpenSort: { isExploreSortSheetPresented = true }
            )
        case .path:
            APathView(
                completedActions: completedAPathActions,
                onOpenHelp: { isAPathHelpPresented = true },
                onOpenSimulator: { navigationPath.append(.aPathSimulator) },
                onOpenAction: openAPathAction
            )
        case .saved:
            SavedView(
                savedIDs: $savedIDs,
                onOpenOpportunity: open,
                onOpenNotifications: openNotificationCenter,
                onOpenActions: { selectedSavedOpportunityForActions = $0 },
                isRemovalToastVisible: savedRemovalToastOpportunity != nil,
                pendingRemoval: savedRemovalToastOpportunity,
                onExplore: { selectedTab = .explore }
            )
        case .my:
            MyView(
                isDarkMode: $isDarkMode,
                profile: $profile,
                completedAPathActions: completedAPathActions,
                onOpenNotificationSettings: openNotificationSettings,
                onPresentConditionSheet: { isConditionSheetPresented = true },
                onOpenSettings: { navigationPath.append(.settings) },
                onOpenActivityHistory: { navigationPath.append(.activityHistory) },
                onOpenHelp: { navigationPath.append(.help) },
                onLogout: { accountConfirmation = .logout }
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

    private var ignoredOpportunityIDs: Set<String> {
        Set(ignoredExploreOpportunityIDsStorage.split(separator: "|").map(String.init))
    }

    private var ignoredOpportunityIDsBinding: Binding<Set<String>> {
        Binding(
            get: { ignoredOpportunityIDs },
            set: { ignoredExploreOpportunityIDsStorage = $0.sorted().joined(separator: "|") }
        )
    }

    private func ignoreOpportunityInExplore(_ id: String) {
        var ignoredIDs = ignoredOpportunityIDs
        ignoredIDs.insert(id)
        ignoredExploreOpportunityIDsStorage = ignoredIDs.sorted().joined(separator: "|")
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
