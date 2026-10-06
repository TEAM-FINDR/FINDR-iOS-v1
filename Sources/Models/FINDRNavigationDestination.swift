enum FINDRNavigationDestination: Hashable {
    case opportunity(Opportunity)
    case aPathSimulator
    case aPathAction(APathActionID)
    case aPathUnlocked(APathActionID)
    case notifications
    case notificationSettings
}
