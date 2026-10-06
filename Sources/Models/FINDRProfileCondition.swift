import Foundation

enum FINDRProfileCondition: String, CaseIterable, Codable, Hashable, Identifiable {
    case certification
    case education
    case project
    case portfolio
    case award
    case career

    var id: String { rawValue }

    var title: String {
        switch self {
        case .certification: "정보처리 관련 자격증 1개"
        case .education: "교육 이수 2개"
        case .project: "프로젝트 1개"
        case .portfolio: "포트폴리오"
        case .award: "수상·활동 경험"
        case .career: "경력"
        }
    }

    var shortTitle: String {
        switch self {
        case .certification: "자격증"
        case .education: "교육 이수"
        case .project: "프로젝트"
        case .portfolio: "포트폴리오"
        case .award: "수상·활동 경험"
        case .career: "경력"
        }
    }

    var iconName: String {
        switch self {
        case .certification: FINDRAssetName.award
        case .education: FINDRAssetName.graduation
        case .project: FINDRAssetName.rocket
        case .portfolio: FINDRAssetName.file
        case .award: FINDRAssetName.aPathOpportunityTrophy
        case .career: FINDRAssetName.building
        }
    }
}
