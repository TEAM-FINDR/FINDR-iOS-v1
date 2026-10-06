import XCTest
@testable import FINDR

final class OnboardingFlowStepTests: XCTestCase {
    func testIntroductionAdvancesThroughA2A3A4ThenLogin() {
        XCTAssertEqual(FINDROnboardingFlowStep.introduction(1).advancingIntroduction(), .introduction(2))
        XCTAssertEqual(FINDROnboardingFlowStep.introduction(2).advancingIntroduction(), .introduction(3))
        XCTAssertEqual(FINDROnboardingFlowStep.introduction(3).advancingIntroduction(), .login)
    }

    func testProfileAdvancesThroughA6ToA9ThenAnalysis() {
        XCTAssertEqual(FINDROnboardingFlowStep.profile(1).advancingProfile(), .profile(2))
        XCTAssertEqual(FINDROnboardingFlowStep.profile(2).advancingProfile(), .profile(3))
        XCTAssertEqual(FINDROnboardingFlowStep.profile(3).advancingProfile(), .profile(4))
        XCTAssertEqual(FINDROnboardingFlowStep.profile(4).advancingProfile(), .analyzing)
    }

    func testProfileBackActionReturnsToPreviousPageOrLogin() {
        XCTAssertEqual(FINDROnboardingFlowStep.profile(4).goingBackFromProfile(), .profile(3))
        XCTAssertEqual(FINDROnboardingFlowStep.profile(2).goingBackFromProfile(), .profile(1))
        XCTAssertEqual(FINDROnboardingFlowStep.profile(1).goingBackFromProfile(), .login)
    }

    func testInvalidTransitionLeavesStepUnchanged() {
        XCTAssertEqual(FINDROnboardingFlowStep.result.advancingIntroduction(), .result)
        XCTAssertEqual(FINDROnboardingFlowStep.login.advancingProfile(), .login)
        XCTAssertEqual(FINDROnboardingFlowStep.analyzing.goingBackFromProfile(), .analyzing)
    }
}
