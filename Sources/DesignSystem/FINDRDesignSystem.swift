import SwiftUI
import UIKit

enum FINDRColor {
    static let canvas = dynamic(light: 0xF6F7FB, dark: 0x0B1020)
    static let surface = dynamic(light: 0xFFFFFF, dark: 0x141A2C)
    static let scrim = Color(uiColor: UIColor(rgb: 0x0B0B0F))
    static let subtle = dynamic(light: 0xF2F4F7, dark: 0x1C2338)
    static let primaryText = dynamic(light: 0x111827, dark: 0xE6E9F0)
    static let heading = dynamic(light: 0x0E1A3A, dark: 0xE6E9F0)
    static let secondaryText = dynamic(light: 0x5B6474, dark: 0xB4BBCB)
    static let tertiaryText = dynamic(light: 0x686C75, dark: 0x7C859C)
    static let brand = dynamic(light: 0x2B62E9, dark: 0x5B8CFF)
    static let brandButton = dynamic(light: 0x2B62E9, dark: 0x2F6BFF)
    static let brandSubtle = dynamic(light: 0xEAF1FF, dark: 0x1A2A55)
    static let brandTint = dynamic(light: 0xEDF2FF, dark: 0x1A2A55)
    static let border = dynamic(light: 0xECEEF3, dark: 0x262E45)
    static let borderStrong = dynamic(light: 0xD8DCE3, dark: 0x343D57)
    static let divider = dynamic(light: 0xECEEF3, dark: 0x262E45)
    static let track = dynamic(light: 0xE3E7EE, dark: 0x262E45)
    static let inverse = dynamic(light: 0x0E1A3A, dark: 0x343D57)
    static let inverseSecondary = dynamic(light: 0xFFFFFF, dark: 0xC9D3F0)
    static let success = dynamic(light: 0x0C7B47, dark: 0x32D583)
    static let successStrong = dynamic(light: 0x067A4A, dark: 0x32D583)
    static let successStatus = dynamic(light: 0x12B76A, dark: 0x32D583)
    static let successSubtle = dynamic(light: 0xE7F8EF, dark: 0x0F2E22)
    static let warning = dynamic(light: 0xA25D00, dark: 0xFDB022)
    static let warningStatus = dynamic(light: 0xF08A00, dark: 0xFDB022)
    static let warningSubtle = dynamic(light: 0xFFF4E5, dark: 0x33240A)
    static let danger = dynamic(light: 0xC23742, dark: 0xF97066)
    static let dangerStatus = dynamic(light: 0xF04452, dark: 0xF97066)
    static let dangerSubtle = dynamic(light: 0xFFECEE, dark: 0x3A1519)
    static let accentSubtle = dynamic(light: 0xF3EEFF, dark: 0x251C47)
    static let inactiveIcon = dynamic(light: 0x98A2B3, dark: 0x7C859C)

    private static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

enum FINDRShadow {
    static let card = Color(uiColor: UIColor(rgb: 0x0F1733)).opacity(0.06)
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}

enum FINDRFont {
    static func regular(_ size: CGFloat) -> Font {
        .custom("NotoSansKR-Thin_Regular", fixedSize: size)
    }

    static func medium(_ size: CGFloat) -> Font {
        .custom("NotoSansKR-Thin_Medium", fixedSize: size)
    }

    static func bold(_ size: CGFloat) -> Font {
        .custom("NotoSansKR-Thin_Bold", fixedSize: size)
    }

    static let titleLarge = bold(26)
    static let title = bold(22)
    static let titleSmall = bold(17)
    static let bodyLargeBold = bold(15)
    static let body = regular(14)
    static let bodyMedium = medium(13)
    static let bodySmall = regular(13)
    static let caption = regular(12)
    static let label = regular(11)
    static let tab = medium(10)
}

enum FINDRSpacing {
    static let xSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let screen: CGFloat = 20
    static let section: CGFloat = 24
    static let xLarge: CGFloat = 32
}

enum FINDRRadius {
    static let small: CGFloat = 6
    static let medium: CGFloat = 12
    static let card: CGFloat = 16
    static let pill: CGFloat = 999
}

enum FINDRAssetName {
    static let logo = "FINDRLogo"
    static let loginLogo = "FINDRLoginLogo"
    static let sparkles = "FINDRSparkles"
    static let onboardingAnalysisSparkles = "OnboardingAnalysisSparkles"
    static let onboardingAnalysisCheckCircle = "OnboardingAnalysisCheckCircle"
    static let onboardingAnalysisClock = "OnboardingAnalysisClock"
    static let onboardingResultCheckCircle = "OnboardingResultCheckCircle"
    static let onboardingResultClock = "OnboardingResultClock"
    static let onboardingResultUnlock = "OnboardingResultUnlock"
    static let onboardingNotificationBell = "OnboardingNotificationBell"
    static let notificationSparkles = "FINDRNotificationSparkles"
    static let notificationEdit = "FINDRNotificationEdit"
    static let notificationMail = "FINDRNotificationMail"
    static let notificationSettings = "FINDRNotificationSettings"
    static let notificationUnlock = "FINDRNotificationUnlock"
    static let notificationClock = "FINDRNotificationClock"
    static let notificationEmptyBell = "FINDRNotificationEmptyBell"
    static let aPathHelp = "Figma_aa157"
    static let aPathClose = "Figma_89e40"
    static let aPathToggleOn = "Figma_b42cc"
    static let aPathBack = "Figma_fd617"
    static let aPathArrowRight = "Figma_2ed21"
    static let aPathPortfolio = "Figma_e6174"
    static let aPathComputer = "Figma_f6e89"
    static let aPathEducation = "Figma_39e7b"
    static let aPathToggleOff = "Figma_6ebf4"
    static let aPathUniversity = "Figma_21071"
    static let aPathLocation = "Figma_8eb99"
    static let aPathListMonitor = "Figma_b197a"
    static let aPathListCPU = "Figma_2a18b"
    static let aPathLink = "Figma_0ce59"
    static let aPathUpload = "Figma_9152e"
    static let aPathFileBadge = "Figma_e938d"
    static let aPathCheck = "Figma_db056"
    static let aPathUnlock = "Figma_a35b1"
    static let aPathOpportunityRocket = "Figma_44c25"
    static let aPathMore = "Figma_76f7a"
    static let aPathOpportunityTrophy = "Figma_67a56"
    static let aPathOpportunityAward = "Figma_04776"
    static let appleLogo = "FINDRAppleLogo"
    static let kakaoLogo = "FINDRKakaoLogo"
    static let profileSetupBack = "Figma_fd617"
    static let profileStatusSelectedRadio = "ProfileStatusSelectedRadio"
    static let exploreActionBookmark = "Figma_a38b7"
    static let exploreActionShare = "Figma_c5038"
    static let exploreActionIgnore = "Figma_b459f"
    static let exploreActionReport = "Figma_7a217"
    static let savedReminder = "FINDRSavedReminder"
    static let savedRemove = "FINDRSavedRemove"
    static let unlock = "Figma_a1402"
    static let bell = "Figma_87021"
    static let cpu = "Figma_d3e89"
    static let homeDeadlineCPU = "Figma_c55a4"
    static let chevronRight = "Figma_5eec4"
    static let folder = "Figma_3ded9"
    static let arrowRight = "Figma_30ec3"
    static let search = "Figma_f4ee6"
    static let recentSearchRemove = "FINDRRecentSearchRemove"
    static let searchClear = "Figma_8e859"
    static let searchEmptyState = "Figma_3bc0e"
    static let searchGraduation = "Figma_d114a"
    static let searchBulb = "Figma_9f781"
    static let searchMonitor = "Figma_c7dbd"
    static let chevronDown = "Figma_76c68"
    static let sliders = "Figma_55e31"
    static let bulb = "Figma_1bfa5"
    static let monitor = "Figma_428cc"
    static let graduation = "Figma_00e68"
    static let award = "Figma_03d6b"
    static let check = "Figma_5eead"
    static let back = "Figma_fd617"
    static let bookmark = "Figma_b6aa8"
    static let savedBookmark = "Figma_3ceed"
    static let saveToastCheck = "Figma_ae8dd"
    static let externalSiteGlobe = "Figma_06e31"
    static let detailShareLink = "Figma_54be6"
    static let detailShareMail = "Figma_1c6c3"
    static let detailShareMore = "Figma_54036"
    static let share = "Figma_23dbf"
    static let building = "Figma_150c8"
    static let calendar = "Figma_246db"
    static let checkCircle = "Figma_417cd"
    static let detailCertificateAward = "Figma_4b7c1"
    static let onboardingCheckCircle = "OnboardingCheckCircle"
    static let onboardingUnlock = "OnboardingUnlock"
    static let gift = "Figma_36165"
    static let missing = "Figma_d04e7"
    static let alert = "Figma_635c1"
    static let help = "Figma_4058b"
    static let pathArrow = "Figma_7a7ca"
    static let file = "Figma_6b0e1"
    static let rocket = "Figma_932cf"
    static let more = "Figma_4aa7b"
    static let settings = "Figma_5385d"
    static let profile = "Figma_7b592"
    static let myProfileChevron = "Figma_68411"
    static let mySectionChevron = "Figma_806b6"
    static let myMenuChevron = "Figma_7950b"
    static let myNotificationSettings = "Figma_24ece"
    static let myHelp = "Figma_c22b7"
    static let plus = "Figma_cc713"
    static let clock = "Figma_00ade"
    static let logout = "Figma_ef8b8"
    static let tabHome = "Figma_ce2eb"
    static let tabExplore = "Figma_037b2"
    static let tabPath = "Figma_fbb8a"
    static let tabSaved = "Figma_2dbe1"
    static let tabMy = "Figma_0c7a2"
    static let detailContactBuilding = "Figma_eb6b3"
    static let detailContactPhone = "Figma_38835"
    static let detailContactChevron = "Figma_6f7ff"
    static let detailContactEmail = "Figma_431cf"
    static let detailContactWebsite = "Figma_5e980"
    static let detailContactNotice = "Figma_e6174"
}

struct FINDRIcon: View {
    let name: String
    var size: CGFloat = 20
    var tint: Color = FINDRColor.primaryText
    var usesTemplate: Bool = true

    var body: some View {
        Image(name)
            .renderingMode(usesTemplate ? .template : .original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(tint)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

struct FINDRCard<Content: View>: View {
    var padding: CGFloat = FINDRSpacing.large
    var cornerRadius: CGFloat = FINDRRadius.card
    var hasShadow = false
    let content: Content

    init(
        padding: CGFloat = FINDRSpacing.large,
        cornerRadius: CGFloat = FINDRRadius.card,
        hasShadow: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.hasShadow = hasShadow
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(FINDRColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
            .shadow(color: hasShadow ? FINDRShadow.card : .clear, radius: 18, x: 0, y: 4)
    }
}

enum FINDRTagTone {
    case neutral, brand, success, warning, danger

    var background: Color {
        switch self {
        case .neutral: FINDRColor.subtle
        case .brand: FINDRColor.brandSubtle
        case .success: FINDRColor.successSubtle
        case .warning: FINDRColor.warningSubtle
        case .danger: FINDRColor.dangerSubtle
        }
    }

    var foreground: Color {
        switch self {
        case .neutral: FINDRColor.secondaryText
        case .brand: FINDRColor.brand
        case .success: FINDRColor.success
        case .warning: FINDRColor.warning
        case .danger: FINDRColor.danger
        }
    }
}

struct FINDRTag: View {
    let title: String
    var tone: FINDRTagTone = .neutral
    var font: Font = FINDRFont.label
    var kerning: CGFloat = -0.2
    var textHeight: CGFloat? = nil
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 4

    var body: some View {
        tagLabel
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(tone.background, in: RoundedRectangle(cornerRadius: FINDRRadius.small, style: .continuous))
            .fixedSize()
    }

    @ViewBuilder
    private var tagLabel: some View {
        if let textHeight {
            Text(title)
                .font(font)
                .kerning(kerning)
                .foregroundStyle(tone.foreground)
                .frame(height: textHeight)
        } else {
            Text(title)
                .font(font)
                .kerning(kerning)
                .foregroundStyle(tone.foreground)
        }
    }
}

struct FINDRPill: View {
    let title: String
    var isSelected = false
    var selectedTone: FINDRTagTone = .brand
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(isSelected ? FINDRFont.bold(13) : FINDRFont.regular(13))
                .kerning(-0.26)
                .foregroundStyle(isSelected ? Color.white : FINDRColor.secondaryText)
                .frame(height: 18)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? FINDRColor.brandButton : FINDRColor.subtle, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct FINDRProgressBar: View {
    let progress: Double
    var color: Color = FINDRColor.brand
    var height: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(FINDRColor.track)
                Capsule()
                    .fill(color)
                    .frame(width: max(0, geometry.size.width * min(max(progress, 0), 1)))
            }
        }
        .frame(height: height)
        .accessibilityElement()
        .accessibilityLabel("진행률")
        .accessibilityValue("\(Int(progress * 100))퍼센트")
    }
}

struct FINDRStatusBadge: View {
    let status: OpportunityStatus

    var body: some View {
        FINDRTag(title: status.label, tone: status.tone, font: FINDRFont.bold(11), horizontalPadding: 8, verticalPadding: 4)
    }
}

struct FINDRSectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var actionIconName: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(FINDRFont.bold(17))
                .kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText)
            Spacer(minLength: 8)
            if let actionTitle {
                Button(action: { action?() }) {
                    HStack(spacing: 2) {
                        Text(actionTitle)
                            .font(FINDRFont.regular(12))
                            .kerning(-0.24)
                            .foregroundStyle(FINDRColor.tertiaryText)
                        if let actionIconName {
                            FINDRIcon(name: actionIconName, size: 14, tint: FINDRColor.tertiaryText)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

enum FINDRButtonKind: Equatable {
    case primary, secondary, outline, accent
    case inverse
}

struct FINDRButton: View {
    let title: String
    var kind: FINDRButtonKind = .primary
    var height: CGFloat = 54
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FINDRFont.bold(15))
                .kerning(-0.3)
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    if kind == .outline {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(FINDRColor.borderStrong, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var foreground: Color {
        switch kind {
        case .primary, .inverse, .accent: .white
        case .secondary, .outline: FINDRColor.primaryText
        }
    }

    private var background: Color {
        switch kind {
        case .primary: FINDRColor.brandButton
        case .accent: FINDRColor.brand
        case .secondary: FINDRColor.inverse
        case .outline: FINDRColor.surface
        case .inverse: FINDRColor.inverse
        }
    }
}

struct FINDRBottomCTA: View {
    let title: String
    var buttonKind: FINDRButtonKind = .primary
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        VStack(spacing: FINDRSpacing.large) {
            FINDRButton(title: title, kind: buttonKind, height: 53, action: action)
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.45)

            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.medium)
        .padding(.bottom, FINDRSpacing.small)
        .frame(maxWidth: .infinity)
        .background(FINDRColor.surface)
        .ignoresSafeArea(edges: .bottom)
    }
}

enum FINDRTab: String, CaseIterable, Identifiable, Hashable {
    case home, explore, path, saved, my

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "홈"
        case .explore: "탐색"
        case .path: "A-Path"
        case .saved: "저장"
        case .my: "MY"
        }
    }

    var iconName: String {
        switch self {
        case .home: FINDRAssetName.tabHome
        case .explore: FINDRAssetName.tabExplore
        case .path: FINDRAssetName.tabPath
        case .saved: FINDRAssetName.tabSaved
        case .my: FINDRAssetName.tabMy
        }
    }
}

struct FINDRTabBar: View {
    @Binding var selection: FINDRTab

    var body: some View {
        VStack(spacing: FINDRSpacing.medium) {
            HStack(spacing: 0) {
                ForEach(FINDRTab.allCases) { tab in
                    Button {
                        selection = tab
                    } label: {
                        VStack(spacing: FINDRSpacing.xSmall) {
                            FINDRIcon(name: tab.iconName, size: 24, tint: selection == tab ? FINDRColor.brandButton : FINDRColor.inactiveIcon)
                            Text(tab.title)
                                .font(selection == tab ? FINDRFont.bold(10) : FINDRFont.medium(10))
                                .foregroundStyle(selection == tab ? FINDRColor.brandButton : FINDRColor.tertiaryText)
                                .frame(height: 14)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.title)
                    .accessibilityAddTraits(selection == tab ? .isSelected : [])
                }
            }
            .padding(.horizontal, FINDRSpacing.small)

            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
        }
        .padding(.top, 11)
        .padding(.bottom, 14)
        .frame(height: 84)
        .background(FINDRColor.surface.ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }
        .ignoresSafeArea(edges: .bottom)
    }
}
