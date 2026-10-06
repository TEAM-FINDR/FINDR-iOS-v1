enum FINDROnboardingFlowStep: Equatable {
    case splash
    case introduction(Int)
    case login
    case profile(Int)
    case analyzing
    case result

    func advancingIntroduction() -> Self {
        guard case .introduction(let page) = self else { return self }
        return page < 3 ? .introduction(page + 1) : .login
    }

    func advancingProfile() -> Self {
        guard case .profile(let page) = self else { return self }
        return page < 4 ? .profile(page + 1) : .analyzing
    }

    func goingBackFromProfile() -> Self {
        guard case .profile(let page) = self else { return self }
        return page > 1 ? .profile(page - 1) : .login
    }
}
