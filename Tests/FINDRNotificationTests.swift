import XCTest
@testable import FINDR

final class FINDRNotificationTests: XCTestCase {
    func testSampleNotificationsMatchFigmaGroupsAndUnreadCount() {
        let notifications = FINDRNotification.samples

        XCTAssertEqual(notifications.count, 5)
        XCTAssertEqual(notifications.filter { $0.group == .today }.count, 3)
        XCTAssertEqual(notifications.filter { $0.group == .thisWeek }.count, 2)
        XCTAssertEqual(notifications.filter(\.isUnread).count, 2)
        XCTAssertEqual(notifications[0].title, "새로운 기회가 열렸어요")
        XCTAssertEqual(notifications[1].destination, .tab(.saved))
        XCTAssertEqual(notifications[4].destination, .tab(.path))
    }

    func testMarkingNotificationAsReadDoesNotChangeOtherNotifications() {
        var notifications = FINDRNotification.samples

        notifications[0].markAsRead()

        XCTAssertFalse(notifications[0].isUnread)
        XCTAssertTrue(notifications[1].isUnread)
        XCTAssertEqual(notifications.filter(\.isUnread).count, 1)
    }
}
