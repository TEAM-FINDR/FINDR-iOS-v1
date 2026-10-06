import XCTest
@testable import FINDR

final class APathOpportunityProjectionTests: XCTestCase {
    func testDefaultSimulationMatchesFigmaE2() {
        XCTAssertEqual(
            APathOpportunityProjection.projectedCount(
                selectedConditions: APathOpportunityProjection.defaultSelectedConditions,
                completedActions: []
            ),
            49
        )
    }

    func testEmptySimulationKeepsCurrentOpportunityCount() {
        XCTAssertEqual(
            APathOpportunityProjection.projectedCount(
                selectedConditions: [],
                completedActions: []
            ),
            29
        )
    }

    func testSelectedAIConditionAddsFiveOpportunities() {
        let selection = APathOpportunityProjection.defaultSelectedConditions.union([.aiEducation])

        XCTAssertEqual(
            APathOpportunityProjection.projectedCount(
                selectedConditions: selection,
                completedActions: []
            ),
            54
        )
    }

    func testCompletedConditionsAreIncludedOnlyOnce() {
        let completed: Set<APathActionID> = [.portfolio]

        XCTAssertEqual(APathOpportunityProjection.currentCount(completedActions: completed), 41)
        XCTAssertEqual(
            APathOpportunityProjection.projectedCount(
                selectedConditions: APathOpportunityProjection.defaultSelectedConditions,
                completedActions: completed
            ),
            49
        )
    }

    func testActionCategoriesMatchFigmaE1AndE6() {
        XCTAssertEqual(APathActionID.actions(for: .recommended).count, 4)
        XCTAssertEqual(APathActionID.actions(for: .certificate).count, 4)
        XCTAssertEqual(APathActionID.actions(for: .education), [.aiEducation])
        XCTAssertEqual(APathActionID.actions(for: .experience), [.portfolio, .projectExperience])
    }
}
