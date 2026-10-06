import Foundation

struct FINDROnboardingProfile: Codable, Equatable {
    var name = "이시우"
    var birthYear = "2009"
    var region = "광주광역시"
    var status = "고등학생"
    var interests: Set<String> = ["개발", "디자인", "창업"]
    var opportunityTypes: Set<String> = ["교육", "공모전", "창업"]
    var conditions: Set<FINDRProfileCondition> = [.certification, .education, .project]
    var profilePhotoPath: String?

    var age: Int {
        let currentYear = Calendar.current.component(.year, from: .now)
        return max(0, currentYear - (Int(birthYear) ?? currentYear))
    }

    var orderedInterests: [String] {
        FINDROnboardingProfileOptions.myProfileInterests.filter(interests.contains)
    }

    var orderedOpportunityTypes: [String] {
        FINDROnboardingProfileOptions.opportunityTypes.filter(opportunityTypes.contains)
    }

    var orderedConditions: [FINDRProfileCondition] {
        FINDRProfileCondition.allCases.filter(conditions.contains)
    }

    var isValidForSaving: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && canContinue(on: 1)
            && canContinue(on: 2)
            && (1...5).contains(interests.count)
            && !opportunityTypes.isEmpty
    }

    mutating func toggleInterest(_ interest: String) {
        if interests.contains(interest) {
            interests.remove(interest)
        } else if interests.count < 5 {
            interests.insert(interest)
        }
    }

    func canContinue(on page: Int, currentYear: Int = Calendar.current.component(.year, from: .now)) -> Bool {
        switch page {
        case 1:
            guard let year = Int(birthYear) else { return false }
            let hasValidYear = (1900...currentYear).contains(year)
            let hasRegion = !region.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return hasValidYear && hasRegion
        case 3:
            return !interests.isEmpty
        case 4:
            return !opportunityTypes.isEmpty
        default:
            return !status.isEmpty
        }
    }
}
