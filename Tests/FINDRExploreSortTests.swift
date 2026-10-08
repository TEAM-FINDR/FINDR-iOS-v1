import XCTest
@testable import FINDR

final class FINDRExploreSortTests: XCTestCase {
    private let opportunities = Opportunity.samples

    func testRecommendedSortKeepsCatalogOrder() {
        XCTAssertEqual(
            FINDRExploreSort.recommended.sorted(opportunities).map(\.id),
            opportunities.map(\.id)
        )
    }

    func testDeadlineSortPlacesSoonestDeadlinesFirst() {
        XCTAssertEqual(
            Array(FINDRExploreSort.deadline.sorted(opportunities).prefix(3).map(\.id)),
            ["app-dev-hackathon", "gwangju-ai-camp", "youth-startup-contest"]
        )
    }

    func testLatestPreviewReversesFixtureOrder() {
        XCTAssertEqual(
            FINDRExploreSort.latest.sorted(opportunities).map(\.id),
            opportunities.reversed().map(\.id)
        )
    }

    func testEligibilitySortPlacesHighestCompletionFirst() {
        let ratios = FINDRExploreSort.eligibility.sorted(opportunities).map(\.progress)

        XCTAssertEqual(ratios, ratios.sorted(by: >))
    }
}
