import Foundation

struct FINDRSearchResult: Identifiable {
    let opportunity: Opportunity
    let artwork: OpportunityArtwork
    let iconName: String
    var usesDarkIcon = false

    var id: String { opportunity.id }
}

enum FINDRSearchCatalog {
    private static let featuredAIResults = [
        FINDRSearchResult(
            opportunity: Opportunity.samples[0],
            artwork: .cpu,
            iconName: FINDRAssetName.homeDeadlineCPU,
            usesDarkIcon: true
        ),
        FINDRSearchResult(
            opportunity: Opportunity.samples[3],
            artwork: .graduation,
            iconName: FINDRAssetName.searchGraduation
        ),
        FINDRSearchResult(
            opportunity: Opportunity(
                id: "search-ai-youth-idea-contest",
                title: "청소년 AI 아이디어 공모전",
                organization: "한국지능정보사회진흥원",
                location: "온라인",
                deadline: "D-10",
                dateRange: nil,
                categories: ["공모전", "AI", "온라인"],
                artwork: .bulb,
                status: .nearlyEligible,
                completedConditions: 3,
                totalConditions: 4,
                conditionNames: ["청소년 대상", "학생 조건", "AI 분야", "아이디어 제안서 제출"],
                missingCondition: "아이디어 제안서 제출"
            ),
            artwork: .bulb,
            iconName: FINDRAssetName.searchBulb
        ),
        FINDRSearchResult(
            opportunity: Opportunity(
                id: "search-ai-app-development-hackathon",
                title: "AI 활용 앱 개발 해커톤",
                organization: "네이버 CONNECT",
                location: "서울",
                deadline: "D-3",
                dateRange: nil,
                categories: ["공모전", "개발", "AI", "서울"],
                artwork: .monitor,
                status: .missing,
                completedConditions: 2,
                totalConditions: 4,
                conditionNames: ["청소년 대상", "학생 조건", "AI·개발 분야", "팀 포트폴리오 제출"],
                missingCondition: "팀 포트폴리오 제출"
            ),
            artwork: .monitor,
            iconName: FINDRAssetName.searchMonitor
        ),
        FINDRSearchResult(
            opportunity: Opportunity(
                id: "search-ai-design-workshop",
                title: "AI 디자인 워크숍",
                organization: "광주디자인진흥원",
                location: "광주",
                deadline: "D-18",
                dateRange: nil,
                categories: ["교육", "AI", "디자인", "광주"],
                artwork: .homeDeadlineAward,
                status: .eligible,
                completedConditions: 4,
                totalConditions: 4,
                conditionNames: ["청소년 대상", "광주 지역", "AI 분야", "참가 신청서 제출"],
                missingCondition: nil
            ),
            artwork: .homeDeadlineAward,
            iconName: FINDRAssetName.aPathOpportunityAward
        )
    ]

    static func results(for query: String) -> [FINDRSearchResult] {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return [] }

        let localResults = Opportunity.samples.map { opportunity in
            FINDRSearchResult(
                opportunity: opportunity,
                artwork: opportunity.artwork,
                iconName: opportunity.artwork.icon
            )
        }
        var seenIDs = Set<String>()

        return (featuredAIResults + localResults).filter { result in
            let opportunity = result.opportunity
            let matches = opportunity.title.localizedCaseInsensitiveContains(term)
                || opportunity.organization.localizedCaseInsensitiveContains(term)
                || opportunity.location.localizedCaseInsensitiveContains(term)
            return matches && seenIDs.insert(result.id).inserted
        }
    }

    static func resultCount(for query: String, matching results: [FINDRSearchResult]) -> Int {
        query.trimmingCharacters(in: .whitespacesAndNewlines).localizedCaseInsensitiveCompare("AI") == .orderedSame
            ? 14
            : results.count
    }
}
