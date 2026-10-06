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

    func testCompletionConfirmationCopyIsNaturalForEachAction() {
        XCTAssertEqual(
            APathActionID.portfolio.completionConfirmationTitle,
            "포트폴리오 만들기를 완료로 표시할까요?"
        )
        XCTAssertEqual(
            APathActionID.aiEducation.completionConfirmationTitle,
            "AI 관련 교육 수료를 완료로 표시할까요?"
        )
        XCTAssertEqual(
            APathActionID.computerLiteracy.completionConfirmationTitle,
            "컴퓨터활용능력 2급 취득을 완료로 표시할까요?"
        )
    }

    func testCertificateActionIconsMatchFigmaE6() {
        XCTAssertEqual(APathActionID.computerLiteracy.iconName, FINDRAssetName.file)
        XCTAssertEqual(APathActionID.dataProcessing.iconName, FINDRAssetName.aPathListMonitor)
        XCTAssertEqual(APathActionID.gtq.iconName, FINDRAssetName.aPathListCPU)
        XCTAssertEqual(APathActionID.koreanHistory.iconName, FINDRAssetName.rocket)
    }

    func testPortfolioUnlockedSamplesAreNotReusedForOtherActions() {
        XCTAssertEqual(Opportunity.aPathUnlockedSamples(for: .portfolio).count, 3)
        XCTAssertTrue(Opportunity.aPathUnlockedSamples(for: .computerLiteracy).isEmpty)
        XCTAssertTrue(Opportunity.aPathUnlockedSamples(for: .aiEducation).isEmpty)
    }
}
