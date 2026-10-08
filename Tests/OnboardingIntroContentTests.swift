import XCTest
@testable import FINDR

final class OnboardingIntroContentTests: XCTestCase {
    func testA2ContentShowsAvailableOpportunities() {
        let content = FINDROnboardingIntroPageContent.a2

        XCTAssertEqual(content.badge, "지원 가능 29개")
        XCTAssertEqual(content.title, "지금 지원 가능한 기회를\n한눈에")
        XCTAssertEqual(content.description, "흩어진 교육·공모전·장학금·지원사업을 모아\n내 조건으로 바로 걸러드려요.")
        XCTAssertEqual(content.buttonTitle, "다음")
        XCTAssertEqual(content.icon, .sparkles)
        XCTAssertFalse(content.usesPillBadge)
    }

    func testA3ContentExplainsMissingConditions() {
        let content = FINDROnboardingIntroPageContent.a3

        XCTAssertEqual(content.badge, "4/5 조건 충족")
        XCTAssertEqual(content.title, "무엇이 부족한지\n정확하게")
        XCTAssertEqual(content.description, "지원이 안 되는 기회는 어떤 조건이\n부족한지 알려드려요.")
        XCTAssertEqual(content.buttonTitle, "다음")
        XCTAssertEqual(content.icon, .checkCircle)
        XCTAssertFalse(content.usesPillBadge)
    }

    func testA4ContentShowsNewOpportunitiesAndFinalAction() {
        let content = FINDROnboardingIntroPageContent.a4

        XCTAssertEqual(content.badge, "+12개의 새로운 기회")
        XCTAssertEqual(content.title, "다음 행동이 여는\n새로운 기회")
        XCTAssertEqual(content.description, "포트폴리오, 자격증, 교육…\n무엇을 하면 몇 개의 기회가 열리는지 보여드려요.")
        XCTAssertEqual(content.buttonTitle, "시작하기")
        XCTAssertEqual(content.icon, .unlock)
        XCTAssertTrue(content.usesPillBadge)
    }
}
