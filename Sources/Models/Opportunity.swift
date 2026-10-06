import SwiftUI

enum OpportunityStatus: String, Hashable {
    case eligible
    case nearlyEligible
    case missing

    var label: String {
        switch self {
        case .eligible: "지원 가능"
        case .nearlyEligible: "거의 가능"
        case .missing: "조건 부족"
        }
    }

    var tone: FINDRTagTone {
        switch self {
        case .eligible: .success
        case .nearlyEligible: .warning
        case .missing: .danger
        }
    }

    var progressColor: Color {
        switch self {
        case .eligible: FINDRColor.successStatus
        case .nearlyEligible: FINDRColor.warningStatus
        case .missing: FINDRColor.dangerStatus
        }
    }
}

enum OpportunityArtwork: String, Hashable {
    case cpu, bulb, monitor, graduation, award, aPathRocket, aPathTrophy, aPathAward

    var icon: String {
        switch self {
        case .cpu: FINDRAssetName.cpu
        case .bulb: FINDRAssetName.bulb
        case .monitor: FINDRAssetName.monitor
        case .graduation: FINDRAssetName.graduation
        case .award: FINDRAssetName.award
        case .aPathRocket: FINDRAssetName.aPathOpportunityRocket
        case .aPathTrophy: FINDRAssetName.aPathOpportunityTrophy
        case .aPathAward: FINDRAssetName.aPathOpportunityAward
        }
    }

    var gradient: Gradient {
        switch self {
        case .cpu:
            let start = Color(hex: 0x4F8BFF)
            let end = Color(hex: 0x1B2F7A)
            return Gradient(stops: [
                .init(color: start, location: 0),
                .init(color: end, location: 0.71429),
                .init(color: end, location: 1)
            ])
        case .bulb: return Gradient(colors: [Color(hex: 0xFF9D4D), Color(hex: 0xF4512C)])
        case .monitor: return Gradient(colors: [Color(hex: 0x8A70FF), Color(hex: 0x3523A8)])
        case .graduation: return Gradient(colors: [Color(hex: 0x28C9B0), Color(hex: 0x08777A)])
        case .award: return Gradient(colors: [Color(hex: 0xF278AA), Color(hex: 0xC21E67)])
        case .aPathRocket, .aPathTrophy, .aPathAward:
            return Gradient(colors: [Color(hex: 0x4B8BFF), Color(hex: 0x183C9B)])
        }
    }
}

struct Opportunity: Identifiable, Hashable {
    let id: String
    let title: String
    let organization: String
    let location: String
    let deadline: String
    let dateRange: String
    let categories: [String]
    let artwork: OpportunityArtwork
    let status: OpportunityStatus
    let completedConditions: Int
    let totalConditions: Int
    let conditionNames: [String]
    let missingCondition: String?

    var progress: Double {
        guard totalConditions > 0 else { return 0 }
        return Double(completedConditions) / Double(totalConditions)
    }

    static let samples: [Opportunity] = [
        Opportunity(
            id: "gwangju-ai-camp", title: "광주 청소년 AI 캠프", organization: "광주광역시교육청", location: "광주",
            deadline: "D-7", dateRange: "2026.10.01 ~ 2026.10.08", categories: ["교육", "광주", "청소년"],
            artwork: .cpu, status: .eligible, completedConditions: 4, totalConditions: 4,
            conditionNames: ["나이 조건 (만 14세 ~ 19세)", "지역 조건 (광주광역시 거주 또는 재학)", "학생 조건 (중·고등학생)", "관심 분야 (AI, SW 관련)"], missingCondition: nil
        ),
        Opportunity(
            id: "youth-startup-contest", title: "2026 청소년 창업 아이디어 공모전", organization: "중소벤처기업부", location: "온라인",
            deadline: "D-12", dateRange: "2026.10.01 ~ 2026.10.20", categories: ["공모전", "창업", "온라인"],
            artwork: .bulb, status: .nearlyEligible, completedConditions: 3, totalConditions: 4,
            conditionNames: ["나이 조건 (만 14세 ~ 19세)", "학생 조건 (중·고등학생)", "관심 분야 (창업)", "아이디어 제안서 제출"], missingCondition: "아이디어 제안서"
        ),
        Opportunity(
            id: "app-dev-hackathon", title: "전국 고교생 앱 개발 해커톤", organization: "네이버 CONNECT", location: "서울",
            deadline: "D-3", dateRange: "2026.10.02 ~ 2026.10.18", categories: ["공모전", "개발", "서울"],
            artwork: .monitor, status: .missing, completedConditions: 2, totalConditions: 4,
            conditionNames: ["나이 조건 (만 14세 ~ 19세)", "학생 조건 (중·고등학생)", "관심 분야 (개발)", "팀 포트폴리오 제출"], missingCondition: "포트폴리오"
        ),
        Opportunity(
            id: "ai-sw-program", title: "AI·SW 인재 양성 프로그램", organization: "과학기술정보통신부", location: "온라인",
            deadline: "D-15", dateRange: "2026.10.05 ~ 2026.11.01", categories: ["교육", "AI", "온라인"],
            artwork: .graduation, status: .eligible, completedConditions: 4, totalConditions: 4,
            conditionNames: ["나이 조건 (만 14세 ~ 19세)", "지역 조건 (전국)", "학생 조건 (중·고등학생)", "관심 분야 (AI·SW)"], missingCondition: nil
        ),
        Opportunity(
            id: "design-bootcamp", title: "청소년 디자인 교육 부트캠프", organization: "광주디자인진흥원", location: "광주",
            deadline: "D-20", dateRange: "2026.10.10 ~ 2026.11.10", categories: ["교육", "디자인", "광주"],
            artwork: .award, status: .eligible, completedConditions: 4, totalConditions: 4,
            conditionNames: ["나이 조건 (만 14세 ~ 19세)", "지역 조건 (광주광역시)", "학생 조건 (중·고등학생)", "관심 분야 (디자인)"], missingCondition: nil
        ),
        Opportunity(
            id: "summer-tech-internship", title: "테크 스타트업 여름 인턴십", organization: "○○ 테크", location: "서울",
            deadline: "D-14", dateRange: "2026.10.01 ~ 2026.10.15", categories: ["인턴", "서울", "온라인"],
            artwork: .cpu, status: .missing, completedConditions: 4, totalConditions: 5,
            conditionNames: ["나이 조건 (만 18세 이상)", "지역 조건 (전국)", "학생 조건 (고등·대학생)", "관심 분야 (개발)", "포트폴리오 제출 필요"], missingCondition: "포트폴리오"
        )
    ]

    static let aPathUnlockedSamples: [Opportunity] = [
        Opportunity(
            id: "apath-summer-tech-internship", title: "테크 스타트업 여름 인턴십",
            organization: "○○ 테크", location: "온라인", deadline: "D-14",
            dateRange: "2026.10.01 ~ 2026.10.15", categories: ["인턴", "온라인"],
            artwork: .aPathRocket, status: .eligible, completedConditions: 5, totalConditions: 5,
            conditionNames: ["나이 조건", "학생 조건", "관심 분야", "지역 조건", "포트폴리오"],
            missingCondition: nil
        ),
        Opportunity(
            id: "apath-youth-sw-contest", title: "청소년 SW 개발 공모전",
            organization: "정보통신산업진흥원", location: "온라인", deadline: "D-18",
            dateRange: "2026.10.01 ~ 2026.10.19", categories: ["공모전", "개발", "온라인"],
            artwork: .aPathTrophy, status: .eligible, completedConditions: 4, totalConditions: 4,
            conditionNames: ["나이 조건", "학생 조건", "관심 분야", "포트폴리오"],
            missingCondition: nil
        ),
        Opportunity(
            id: "apath-ux-design-bootcamp", title: "UX 디자인 부트캠프",
            organization: "광주디자인진흥원", location: "광주", deadline: "D-25",
            dateRange: "2026.10.01 ~ 2026.10.26", categories: ["교육", "디자인", "광주"],
            artwork: .aPathAward, status: .eligible, completedConditions: 4, totalConditions: 4,
            conditionNames: ["나이 조건", "지역 조건", "학생 조건", "포트폴리오"],
            missingCondition: nil
        )
    ]

    static func aPathUnlockedSamples(for actionID: APathActionID) -> [Opportunity] {
        guard actionID == .portfolio else { return [] }
        return aPathUnlockedSamples
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
