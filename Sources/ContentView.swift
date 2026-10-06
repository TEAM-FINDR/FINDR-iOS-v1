import SwiftUI

struct ContentView: View {
    @AppStorage("FINDR.isDarkMode") private var isDarkMode = false
    @State private var selectedTab: FINDRTab = .home
    @State private var navigationPath: [Opportunity] = []
    @State private var savedIDs: Set<String> = [
        "app-dev-hackathon", "gwangju-ai-camp", "youth-startup-contest", "ai-sw-program", "design-bootcamp"
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            selectedScreen
                .navigationDestination(for: Opportunity.self) { opportunity in
                    OpportunityDetailView(opportunity: opportunity, savedIDs: $savedIDs) {
                        selectedTab = .path
                        navigationPath.removeAll()
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
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    @ViewBuilder
    private var selectedScreen: some View {
        switch selectedTab {
        case .home:
            HomeView(onOpenOpportunity: open, onSeeAll: { selectedTab = .explore })
        case .explore:
            ExploreView(onOpenOpportunity: open)
        case .path:
            APathView()
        case .saved:
            SavedView(savedIDs: $savedIDs, onOpenOpportunity: open)
        case .my:
            MyView(isDarkMode: $isDarkMode)
        }
    }

    private func open(_ opportunity: Opportunity) {
        navigationPath.append(opportunity)
    }
}

#Preview {
    ContentView()
}
