import SwiftUI

enum FINDRNotificationGroup: String, CaseIterable, Identifiable, Hashable {
    case today = "오늘"
    case thisWeek = "이번 주"

    var id: String { rawValue }
}

enum FINDRNotificationDestination: Hashable {
    case opportunity(String)
    case tab(FINDRTab)
}

enum FINDRNotificationKind: Hashable {
    case opportunityOpened
    case deadline
    case eligibilityUpdated
    case announcementUpdated
    case pathRecommendation

    var iconName: String {
        switch self {
        case .opportunityOpened, .pathRecommendation:
            FINDRAssetName.unlock
        case .deadline:
            FINDRAssetName.clock
        case .eligibilityUpdated:
            FINDRAssetName.notificationSparkles
        case .announcementUpdated:
            FINDRAssetName.notificationEdit
        }
    }

    var iconBackground: Color {
        switch self {
        case .opportunityOpened, .pathRecommendation:
            FINDRColor.brandSubtle
        case .deadline:
            FINDRColor.warningSubtle
        case .eligibilityUpdated:
            FINDRColor.successSubtle
        case .announcementUpdated:
            FINDRColor.subtle
        }
    }

    var iconTint: Color {
        switch self {
        case .opportunityOpened, .pathRecommendation:
            FINDRColor.brand
        case .deadline:
            FINDRColor.warningStatus
        case .eligibilityUpdated:
            FINDRColor.successStatus
        case .announcementUpdated:
            FINDRColor.secondaryText
        }
    }
}

struct FINDRNotification: Identifiable, Hashable {
    let id: String
    let group: FINDRNotificationGroup
    let kind: FINDRNotificationKind
    let title: String
    let message: String
    let time: String
    let destination: FINDRNotificationDestination
    var isUnread: Bool

    mutating func markAsRead() {
        isUnread = false
    }

    static let samples: [FINDRNotification] = [
        FINDRNotification(
            id: "new-opportunity-gwangju-ai-camp",
            group: .today,
            kind: .opportunityOpened,
            title: "새로운 기회가 열렸어요",
            message: "광주 청소년 AI 캠프 · 현재 조건으로 지원할 수 있어요.",
            time: "10분 전",
            destination: .opportunity("gwangju-ai-camp"),
            isUnread: true
        ),
        FINDRNotification(
            id: "deadline-app-dev-hackathon",
            group: .today,
            kind: .deadline,
            title: "마감 D-3",
            message: "저장한 전국 고교생 앱 개발 해커톤이 3일 후 마감돼요.",
            time: "1시간 전",
            destination: .tab(.saved),
            isUnread: true
        ),
        FINDRNotification(
            id: "eligible-youth-startup-contest",
            group: .today,
            kind: .eligibilityUpdated,
            title: "지원 가능해졌어요",
            message: "프로필 업데이트로 2026 청소년 창업 아이디어 공모전에 지원할 수 있어요.",
            time: "3시간 전",
            destination: .opportunity("youth-startup-contest"),
            isUnread: false
        ),
        FINDRNotification(
            id: "announcement-ai-sw-program",
            group: .thisWeek,
            kind: .announcementUpdated,
            title: "공고가 변경됐어요",
            message: "AI·SW 인재 양성 프로그램의 모집 인원이 변경되었어요.",
            time: "2일 전",
            destination: .opportunity("ai-sw-program"),
            isUnread: false
        ),
        FINDRNotification(
            id: "path-portfolio-recommendation",
            group: .thisWeek,
            kind: .pathRecommendation,
            title: "A-Path 추천",
            message: "포트폴리오를 만들면 12개의 기회가 새로 열려요.",
            time: "3일 전",
            destination: .tab(.path),
            isUnread: false
        )
    ]
}
