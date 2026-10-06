import Foundation

struct FINDROnboardingProfile {
    var birthYear = "2009"
    var region = "광주광역시"
    var status = "고등학생"
    var interests: Set<String> = ["개발", "디자인", "창업"]
    var opportunityTypes: Set<String> = ["교육", "공모전", "창업"]

    var age: Int {
        let currentYear = Calendar.current.component(.year, from: .now)
        return max(0, currentYear - (Int(birthYear) ?? currentYear))
    }

    var orderedInterests: [String] {
        FINDROnboardingProfileOptions.interests.filter(interests.contains)
    }
}
