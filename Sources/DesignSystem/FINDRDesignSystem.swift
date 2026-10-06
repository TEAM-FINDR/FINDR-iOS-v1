import SwiftUI
import UIKit

enum FINDRColor {
    static let canvas = dynamic(light: 0xF6F7FB, dark: 0x0B1020)
    static let surface = dynamic(light: 0xFFFFFF, dark: 0x141A2C)
    static let subtle = dynamic(light: 0xF2F4F7, dark: 0x1C2338)
    static let primaryText = dynamic(light: 0x111827, dark: 0xE6E9F0)
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
    static let dangerSubtle = dynamic(light: 0xFFEEEE, dark: 0x3A1519)
    static let accentSubtle = dynamic(light: 0xF3EEFF, dark: 0x251C47)
    static let inactiveIcon = dynamic(light: 0x98A2B3, dark: 0x7C859C)

    private static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
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
        .custom("NotoSansKR-Regular", fixedSize: size)
    }

    static func medium(_ size: CGFloat) -> Font {
        .custom("NotoSansKR-Medium", fixedSize: size)
    }

    static func bold(_ size: CGFloat) -> Font {
        .custom("NotoSansKR-Bold", fixedSize: size)
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
    static let notificationSparkles = "FINDRNotificationSparkles"
    static let notificationEdit = "FINDRNotificationEdit"
    static let notificationMail = "FINDRNotificationMail"
    static let appleLogo = "FINDRAppleLogo"
    static let kakaoLogo = "FINDRKakaoLogo"
    static let unlock = "Figma_a1402"
    static let bell = "Figma_87021"
    static let cpu = "Figma_d3e89"
    static let chevronRight = "Figma_5eec4"
    static let folder = "Figma_3ded9"
    static let arrowRight = "Figma_30ec3"
    static let search = "Figma_f4ee6"
    static let chevronDown = "Figma_76c68"
    static let sliders = "Figma_55e31"
    static let bulb = "Figma_1bfa5"
    static let monitor = "Figma_428cc"
    static let graduation = "Figma_00e68"
    static let award = "Figma_03d6b"
    static let check = "Figma_5eead"
    static let back = "Figma_4a022"
    static let bookmark = "Figma_b6aa8"
    static let share = "Figma_23dbf"
    static let building = "Figma_150c8"
    static let calendar = "Figma_246db"
    static let checkCircle = "Figma_417cd"
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
    static let plus = "Figma_cc713"
    static let clock = "Figma_00ade"
    static let logout = "Figma_ef8b8"
    static let tabHome = "Figma_ce2eb"
    static let tabExplore = "Figma_037b2"
    static let tabPath = "Figma_fbb8a"
    static let tabSaved = "Figma_2dbe1"
    static let tabMy = "Figma_0c7a2"
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
            .shadow(color: .black.opacity(hasShadow ? 0.06 : 0), radius: 18, x: 0, y: 4)
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
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 4

    var body: some View {
        Text(title)
            .font(font)
            .kerning(-0.2)
            .foregroundStyle(tone.foreground)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(tone.background, in: RoundedRectangle(cornerRadius: FINDRRadius.small, style: .continuous))
            .fixedSize()
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
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(FINDRFont.bold(17))
                .kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText)
            Spacer(minLength: 8)
            if let actionTitle {
                Button(actionTitle, action: action ?? {})
                    .font(FINDRFont.regular(12))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .buttonStyle(.plain)
            }
        }
    }
}

enum FINDRButtonKind: Equatable {
    case primary, secondary, outline
}

struct FINDRButton: View {
    let title: String
    var kind: FINDRButtonKind = .primary
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FINDRFont.bold(15))
                .kerning(-0.3)
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
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
        case .primary: .white
        case .secondary: FINDRColor.primaryText
        case .outline: FINDRColor.primaryText
        }
    }

    private var background: Color {
        switch kind {
        case .primary: FINDRColor.brandButton
        case .secondary: FINDRColor.inverse
        case .outline: FINDRColor.surface
        }
    }
}

enum FINDRTab: String, CaseIterable, Identifiable {
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
        HStack(spacing: 0) {
            ForEach(FINDRTab.allCases) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 2) {
                        FINDRIcon(name: tab.iconName, size: 24, tint: selection == tab ? FINDRColor.brandButton : FINDRColor.inactiveIcon)
                        Text(tab.title)
                            .font(selection == tab ? FINDRFont.bold(10) : FINDRFont.medium(10))
                            .foregroundStyle(selection == tab ? FINDRColor.brandButton : FINDRColor.tertiaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(selection == tab ? .isSelected : [])
            }
        }
        .padding(.top, 5)
        .background(FINDRColor.surface.ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }
    }
}
