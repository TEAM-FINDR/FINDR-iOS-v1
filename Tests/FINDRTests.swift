import XCTest
@testable import FINDR

final class FINDRTests: XCTestCase {
    func testProfileStartsWithFigmaDefaults() {
        let profile = FINDROnboardingProfile()

        XCTAssertEqual(profile.birthYear, "2009")
        XCTAssertEqual(profile.region, "광주광역시")
        XCTAssertEqual(profile.status, "고등학생")
        XCTAssertEqual(profile.interests, ["개발", "디자인", "창업"])
        XCTAssertEqual(profile.opportunityTypes, ["교육", "공모전", "창업"])
        XCTAssertEqual(profile.conditions, [.certification, .education, .project])
    }

    func testProfileAgeUsesBirthYear() {
        let currentYear = Calendar.current.component(.year, from: .now)
        var profile = FINDROnboardingProfile()
        profile.birthYear = String(currentYear - 17)

        XCTAssertEqual(profile.age, 17)
    }

    func testOrderedInterestsFollowDisplayedOptionOrder() {
        var profile = FINDROnboardingProfile()
        profile.interests = ["창업", "미등록 관심 분야", "개발", "AI·데이터"]

        XCTAssertEqual(profile.orderedInterests, ["개발", "AI·데이터", "창업"])
    }

    func testPersonalInformationValidationRejectsInvalidBirthYearOrRegion() {
        var profile = FINDROnboardingProfile()
        XCTAssertTrue(profile.canContinue(on: 1, currentYear: 2026))

        profile.birthYear = "올해"
        XCTAssertFalse(profile.canContinue(on: 1, currentYear: 2026))

        profile.birthYear = "2027"
        XCTAssertFalse(profile.canContinue(on: 1, currentYear: 2026))

        profile.birthYear = "1899"
        XCTAssertFalse(profile.canContinue(on: 1, currentYear: 2026))

        profile.birthYear = "2009"
        profile.region = "   \n"
        XCTAssertFalse(profile.canContinue(on: 1, currentYear: 2026))
    }

    func testChoicePagesRequireSelections() {
        var profile = FINDROnboardingProfile()

        XCTAssertTrue(profile.canContinue(on: 2))
        profile.status = ""
        XCTAssertFalse(profile.canContinue(on: 2))

        profile.interests = []
        XCTAssertFalse(profile.canContinue(on: 3))
        profile.interests = ["개발"]
        XCTAssertTrue(profile.canContinue(on: 3))

        profile.opportunityTypes = []
        XCTAssertFalse(profile.canContinue(on: 4))
        profile.opportunityTypes = ["교육"]
        XCTAssertTrue(profile.canContinue(on: 4))
    }

    func testInterestsCanBeToggledUpToFive() {
        var profile = FINDROnboardingProfile()
        profile.interests = ["개발", "디자인", "창업", "AI·데이터", "과학"]

        profile.toggleInterest("환경")
        XCTAssertEqual(profile.interests.count, 5)
        XCTAssertFalse(profile.interests.contains("환경"))

        profile.toggleInterest("개발")
        XCTAssertEqual(profile.interests.count, 4)
        XCTAssertFalse(profile.interests.contains("개발"))
    }

    func testProfileStoreRoundTripsProfile() {
        let suiteName = "FINDRProfileStoreTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        var profile = FINDROnboardingProfile()
        profile.name = "테스트 사용자"
        profile.conditions = [.education, .portfolio, .career]
        profile.profilePhotoPath = "profiles/avatar.jpg"
        FINDRProfileStore.save(profile, to: defaults)

        XCTAssertEqual(FINDRProfileStore.load(from: defaults), profile)
    }

    func testProfileStoreFallsBackWhenStoredDataIsInvalid() {
        let suiteName = "FINDRProfileStoreTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(Data("not-json".utf8), forKey: FINDRProfileStore.key)

        XCTAssertEqual(FINDRProfileStore.load(from: defaults), FINDROnboardingProfile())
    }
}
