import SwiftUI

private enum MYEditorDestination: String, Identifiable {
    case profile
    case interests

    var id: String { rawValue }
}

struct MyView: View {
    @Binding var isDarkMode: Bool
    @Binding var profile: FINDROnboardingProfile
    let completedAPathActions: Set<APathActionID>
    let onOpenNotificationSettings: () -> Void
    let onPresentConditionSheet: () -> Void
    let onOpenSettings: () -> Void
    let onOpenActivityHistory: () -> Void
    let onOpenHelp: () -> Void
    let onLogout: () -> Void
    @State private var activeEditor: MYEditorDestination?
    @State private var shouldShowProfileSaveConfirmation = false
    @State private var isProfileSaveConfirmationVisible = false

    private var conditions: [String] {
        return FINDRProfileCondition.allCases
            .filter(ownedConditions.contains)
            .map(\.title)
    }
    private var ownedConditions: Set<FINDRProfileCondition> {
        var values = profile.conditions
        if completedAPathActions.contains(.portfolio) {
            values.insert(.portfolio)
        }
        return values
    }
    private let menuItems: [(String, String)] = [
        ("활동 기록", FINDRAssetName.clock),
        ("알림 설정", FINDRAssetName.myNotificationSettings),
        ("도움말", FINDRAssetName.myHelp),
        ("로그아웃", FINDRAssetName.logout)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                header
                    .frame(height: 41)
                profileCard
                selectionCard(
                    title: "관심 분야",
                    values: profile.orderedInterests,
                    addLabel: "추가",
                    tagTone: .brand,
                    onEdit: { activeEditor = .interests },
                    onAdd: { activeEditor = .interests }
                )
                selectionCard(
                    title: "보유 조건",
                    values: conditions,
                    addLabel: "추가",
                    tagTone: .neutral,
                    onEdit: onPresentConditionSheet,
                    onAdd: onPresentConditionSheet
                )
                menuCard
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 26)
        }
        .background(FINDRColor.canvas)
        .fullScreenCover(item: $activeEditor, onDismiss: presentSaveConfirmationIfNeeded) { destination in
            switch destination {
            case .profile:
                MyProfileEditorView(profile: $profile) {}
            case .interests:
                MyInterestsEditorView(profile: $profile) {
                    shouldShowProfileSaveConfirmation = true
                }
            }
        }
        .overlay {
            if isProfileSaveConfirmationVisible {
                MyProfileSaveConfirmationView {
                    isProfileSaveConfirmationVisible = false
                }
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isProfileSaveConfirmationVisible)

    }

    private var header: some View {
        FINDRPageHeader(
            title: "MY",
            trailingIcon: FINDRAssetName.settings,
            trailingLabel: "설정",
            action: onOpenSettings,
            titleKerning: -0.44
        )
        .contextMenu { Button(isDarkMode ? "라이트 모드로 변경" : "다크 모드로 변경") { isDarkMode.toggle() } }
    }

    private var profileCard: some View {
        FINDRCard(padding: 16, hasShadow: true) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    FINDRProfileAvatar(
                        photoPath: profile.profilePhotoPath,
                        size: 60,
                        gradientStart: Color(hex: 0xA9C3FF),
                        gradientEnd: Color(hex: 0x2F6BFF)
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name)
                            .font(FINDRFont.bold(18))
                            .kerning(-0.36)
                            .foregroundStyle(FINDRColor.primaryText)
                            .frame(height: 25, alignment: .leading)
                        Text(profileSummary)
                            .font(FINDRFont.regular(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.secondaryText)
                            .frame(height: 18, alignment: .leading)
                        Button { activeEditor = .profile } label: {
                            HStack(spacing: 3) {
                                Text("프로필 수정")
                                    .font(FINDRFont.medium(12))
                                FINDRIcon(name: FINDRAssetName.myProfileChevron, size: 14, tint: FINDRColor.brand)
                            }
                            .foregroundStyle(FINDRColor.brand)
                            .frame(height: 17, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .frame(height: 64)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("프로필 완성도")
                            .font(FINDRFont.medium(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.secondaryText)
                        Spacer()
                        Text("70%")
                            .font(FINDRFont.bold(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.brand)
                    }
                    .frame(height: 18)
                    FINDRProgressBar(progress: 0.7, color: FINDRColor.brandButton, height: 6)
                        .frame(width: 289)
                    Text("보유 조건을 추가하면 더 정확하게 추천해드려요")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .frame(height: 17, alignment: .leading)
                }
            }
        }
    }

    private func selectionCard(
        title: String,
        values: [String],
        addLabel: String,
        tagTone: FINDRTagTone,
        onEdit: @escaping () -> Void,
        onAdd: @escaping () -> Void
    ) -> some View {
        FINDRCard(padding: 16, hasShadow: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(FINDRFont.bold(15))
                        .kerning(-0.3)
                        .foregroundStyle(FINDRColor.primaryText)
                        .frame(height: 21, alignment: .leading)
                    Spacer()
                    Button { onEdit() } label: {
                        HStack(spacing: 3) {
                            Text("수정")
                                .font(FINDRFont.regular(12))
                                .kerning(-0.24)
                            FINDRIcon(name: FINDRAssetName.mySectionChevron, size: 14, tint: FINDRColor.tertiaryText)
                        }
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .frame(height: 17)
                    }
                    .buttonStyle(.plain)
                }
                FlowTags(values: values, tone: tagTone, dashedAddLabel: addLabel) {
                    onAdd()
                }
            }
        }
    }

    private var menuCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(menuItems.enumerated()), id: \.offset) { index, item in
                Button {
                    if item.0 == "알림 설정" {
                        onOpenNotificationSettings()
                    } else {
                        switch item.0 {
                        case "활동 기록": onOpenActivityHistory()
                        case "도움말": onOpenHelp()
                        default: onLogout()
                        }
                    }
                } label: {
                    HStack(spacing: 10) {
                        FINDRIcon(name: item.1, size: 18, tint: FINDRColor.secondaryText)
                        Text(item.0)
                            .font(FINDRFont.medium(14))
                            .kerning(-0.28)
                            .foregroundStyle(FINDRColor.primaryText)
                            .frame(height: 20, alignment: .leading)
                        Spacer()
                        FINDRIcon(name: FINDRAssetName.myMenuChevron, size: 16, tint: FINDRColor.inactiveIcon)
                    }
                    .padding(.vertical, 12)
                    .frame(height: index == menuItems.count - 1 ? 44 : 45)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .overlay(alignment: .bottom) {
                    if index < menuItems.count - 1 {
                        FINDRColor.divider
                            .frame(height: 1)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(FINDRColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous)
                .stroke(FINDRColor.border, lineWidth: 1)
        }
        .shadow(color: FINDRShadow.card, radius: 18, x: 0, y: 4)
    }

    private func presentSaveConfirmationIfNeeded() {
        guard shouldShowProfileSaveConfirmation else { return }
        shouldShowProfileSaveConfirmation = false
        isProfileSaveConfirmationVisible = true
    }

    private var profileSummary: String {
        let region = profile.region
            .replacingOccurrences(of: "광주광역시", with: "광주")
            .replacingOccurrences(of: "서울특별시", with: "서울")
            .replacingOccurrences(of: "부산광역시", with: "부산")
        return "\(profile.age)세 · \(region) · \(profile.status)"
    }
}

private struct FlowTags: View {
    let values: [String]
    let tone: FINDRTagTone
    let dashedAddLabel: String
    let onAdd: () -> Void

    var body: some View {
        FINDRProfileChipFlowLayout(horizontalSpacing: 6, verticalSpacing: 6) {
            ForEach(values, id: \.self) { value in
                FINDRTag(
                    title: value,
                    tone: tone,
                    font: FINDRFont.regular(12),
                    kerning: -0.24,
                    textHeight: 17,
                    horizontalPadding: 8,
                    verticalPadding: 4
                )
            }
            addButton
        }
    }

    private var addButton: some View {
        Button(action: onAdd) {
            HStack(spacing: 2) {
                FINDRIcon(name: FINDRAssetName.plus, size: 12, tint: FINDRColor.tertiaryText)
                Text(dashedAddLabel)
                    .font(FINDRFont.medium(12))
            }
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .frame(height: 30)
            .overlay {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(FINDRColor.borderStrong, style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
            }
        }
        .buttonStyle(.plain)
    }
}
