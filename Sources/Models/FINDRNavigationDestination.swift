enum FINDRNavigationDestination: Hashable {
    case opportunity(Opportunity)
    case aPathSimulator
    case aPathAction(APathActionID)
    case aPathUnlocked(APathActionID)
    case notifications
    case notificationSettings
    case recommendedOpportunities
    case search
    case settings
    case activityHistory
    case help
    case searchResults
}
