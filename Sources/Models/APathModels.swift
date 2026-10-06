import SwiftUI

enum APathCategory: String, CaseIterable, Identifiable, Hashable {
    case recommended = "추천 행동"
    case certificate = "자격증"
    case education = "교육"
    case experience = "경험"

    var id: String { rawValue }
}

enum APathConditionID: String, CaseIterable, Hashable, Identifiable {
    case portfolio
    case computerLiteracy
    case aiEducation
    case college
    case seoul

    var id: String { rawValue }

    var title: String {
        switch self {
        case .portfolio: "포트폴리오 보유"
        case .computerLiteracy: "컴퓨터활용능력 2급"
        case .aiEducation: "AI 교육 수료"
        case .college: "대학생이 된다면"
        case .seoul: "서울로 이사한다면"
        }
    }

    var opportunityCount: Int {
        switch self {
        case .portfolio: 12
        case .computerLiteracy: 8
        case .aiEducation: 5
        case .college: 34
        case .seoul: 21
        }
    }

    var iconName: String {
        switch self {
        case .portfolio: FINDRAssetName.aPathPortfolio
        case .computerLiteracy: FINDRAssetName.aPathComputer
        case .aiEducation: FINDRAssetName.aPathEducation
        case .college: FINDRAssetName.aPathUniversity
        case .seoul: FINDRAssetName.aPathLocation
        }
    }

    var completedAction: APathActionID? {
        switch self {
        case .portfolio: .portfolio
        case .computerLiteracy: .computerLiteracy
        case .aiEducation: .aiEducation
        case .college, .seoul: nil
        }
    }
}

enum APathActionID: String, CaseIterable, Hashable, Identifiable {
    case portfolio
    case computerLiteracy
    case aiEducation
    case projectExperience
    case dataProcessing
    case gtq
    case koreanHistory

    var id: String { rawValue }

    var category: APathCategory {
        switch self {
        case .computerLiteracy, .dataProcessing, .gtq, .koreanHistory:
            .certificate
        case .aiEducation:
            .education
        case .portfolio, .projectExperience:
            .experience
        }
    }

    var title: String {
        switch self {
        case .portfolio: "포트폴리오 만들기"
        case .computerLiteracy: "컴퓨터활용능력 2급 취득"
        case .aiEducation: "AI 관련 교육 수료"
        case .projectExperience: "프로젝트 경험 쌓기"
        case .dataProcessing: "정보처리기능사"
        case .gtq: "GTQ 그래픽기술자격"
        case .koreanHistory: "한국사능력검정 3급"
        }
    }

    var categoryTitle: String {
        switch self {
        case .computerLiteracy: "컴퓨터활용능력 2급"
        default: title
        }
    }

    var subtitle: String {
        switch self {
        case .portfolio: "IT·개발 분야 기회가 열려요"
        case .computerLiteracy: "공공기관·대외활동 기회가 열려요"
        case .aiEducation: "교육·해커톤 기회가 열려요"
        case .projectExperience: "공모전 기회가 열려요"
        case .dataProcessing: "IT 인턴·교육 기회가 열려요"
        case .gtq: "디자인 공모전 기회가 열려요"
        case .koreanHistory: "장학금·교육 기회가 열려요"
        }
    }

    var opportunityCount: Int {
        switch self {
        case .portfolio: 12
        case .computerLiteracy: 8
        case .aiEducation: 5
        case .projectExperience: 4
        case .dataProcessing: 6
        case .gtq: 4
        case .koreanHistory: 3
        }
    }

    var iconName: String {
        switch self {
        case .portfolio, .computerLiteracy: FINDRAssetName.aPathPortfolio
        case .aiEducation, .gtq: FINDRAssetName.aPathEducation
        case .projectExperience, .koreanHistory: FINDRAssetName.rocket
        case .dataProcessing: FINDRAssetName.monitor
        }
    }

    var iconTint: Color {
        switch self {
        case .portfolio, .computerLiteracy, .dataProcessing, .koreanHistory:
            FINDRColor.brand
        case .aiEducation:
            FINDRColor.warningStatus
        case .projectExperience:
            FINDRColor.brand
        case .gtq:
            Color(hex: 0xF08A00)
        }
    }

    var iconBackground: Color {
        switch self {
        case .portfolio, .computerLiteracy:
            FINDRColor.brandSubtle
        case .aiEducation:
            FINDRColor.warningSubtle
        case .projectExperience:
            FINDRColor.accentSubtle
        case .dataProcessing:
            FINDRColor.successSubtle
        case .gtq:
            FINDRColor.warningSubtle
        case .koreanHistory:
            FINDRColor.accentSubtle
        }
    }

    var breakdown: [(String, Int)] {
        switch self {
        case .portfolio:
            [("교육", 4), ("공모전", 3), ("인턴", 3), ("지원", 2)]
        case .computerLiteracy:
            [("공공", 4), ("대외활동", 4)]
        case .aiEducation:
            [("교육", 3), ("해커톤", 2)]
        case .projectExperience:
            [("공모전", 4)]
        case .dataProcessing:
            [("IT 인턴", 3), ("교육", 3)]
        case .gtq:
            [("디자인", 4)]
        case .koreanHistory:
            [("장학금", 2), ("교육", 1)]
        }
    }

    var preparationSteps: [String] {
        switch self {
        case .portfolio:
            [
                "보여주고 싶은 프로젝트 2~3개 고르기",
                "노션·깃허브 등에 과정과 결과 정리하기",
                "PDF 또는 링크로 MY › 보유 조건에 등록하기"
            ]
        case .computerLiteracy:
            ["시험 일정을 확인하고 응시 과목 정하기", "기출문제로 실기와 필기 준비하기", "자격증을 취득하면 MY › 보유 조건에 등록하기"]
        case .aiEducation:
            ["관심 있는 AI·SW 교육 과정 찾기", "교육 과정을 수료하고 증빙 자료 준비하기", "수료 정보를 MY › 보유 조건에 등록하기"]
        case .projectExperience:
            ["참여할 프로젝트 주제 정하기", "팀과 함께 결과물을 완성하기", "프로젝트 과정과 결과를 정리하기"]
        case .dataProcessing:
            ["시험 일정을 확인하고 접수하기", "필기와 실기 기출문제 풀기", "자격증을 취득하면 MY › 보유 조건에 등록하기"]
        case .gtq:
            ["응시할 급수와 일정을 확인하기", "기출 과제로 툴 사용을 연습하기", "자격증을 취득하면 MY › 보유 조건에 등록하기"]
        case .koreanHistory:
            ["시험 일정과 목표 급수 정하기", "시대별 핵심 내용을 정리하기", "자격증을 취득하면 MY › 보유 조건에 등록하기"]
        }
    }

    static let recommended: [APathActionID] = [
        .portfolio, .computerLiteracy, .aiEducation, .projectExperience
    ]

    static func actions(for category: APathCategory) -> [APathActionID] {
        switch category {
        case .recommended:
            recommended
        case .certificate:
            [.computerLiteracy, .dataProcessing, .gtq, .koreanHistory]
        case .education:
            [.aiEducation]
        case .experience:
            [.portfolio, .projectExperience]
        }
    }

    var conditionID: APathConditionID? {
        switch self {
        case .portfolio: .portfolio
        case .computerLiteracy: .computerLiteracy
        case .aiEducation: .aiEducation
        case .projectExperience, .dataProcessing, .gtq, .koreanHistory: nil
        }
    }
}

enum APathOpportunityProjection {
    static let baseOpportunityCount = 29

    static let defaultSelectedConditions: Set<APathConditionID> = [
        .portfolio, .computerLiteracy
    ]

    static func currentCount(completedActions: Set<APathActionID>) -> Int {
        baseOpportunityCount + completedActions.reduce(0) { $0 + $1.opportunityCount }
    }

    static func projectedCount(
        selectedConditions: Set<APathConditionID>,
        completedActions: Set<APathActionID>
    ) -> Int {
        let completedConditions = Set(completedActions.compactMap(\.conditionID))
        let simulatedConditions = selectedConditions.subtracting(completedConditions)
        let additionalCount = simulatedConditions.reduce(0) { $0 + $1.opportunityCount }
        return currentCount(completedActions: completedActions) + additionalCount
    }
}
