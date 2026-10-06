import SwiftUI

private enum MYEditorDestination: String, Identifiable {
    case profile

    var id: String { rawValue }
}

struct MyView: View {
    @Binding var isDarkMode: Bool
    @Binding var profile: FINDROnboardingProfile
    let completedAPathActions: Set<APathActionID>
    let onOpenNotificationSettings: () -> Void
    @State private var selectedAction = ""
    @State private var showActionNotice = false
    @State private var activeEditor: MYEditorDestination?
    @State private var shouldShowProfileSaveConfirmation = false
    @State private var isProfileSaveConfirmationVisible = false

    private var conditions: [String] {
        var profileConditions = profile.conditions
        if completedAPathActions.contains(.portfolio) {
            profileConditions.insert(.portfolio)
        }
        return FINDRProfileCondition.allCases
            .filter(profileConditions.contains)
            .map(\.title)
    }
    private let menuItems: [(String, String)] = [
        ("활동 기록", FINDRAssetName.clock),
        ("알림 설정", FINDRAssetName.bell),
        ("도움말", FINDRAssetName.help),
        ("로그아웃", FINDRAssetName.logout)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                header
                profileCard
                selectionCard(title: "관심 분야", values: profile.orderedInterests, addLabel: "추가")
                selectionCard(title: "보유 조건", values: conditions, addLabel: "추가")
                menuCard
                    .padding(.top, 1)
                Text("버전 1.0.0")
                    .font(FINDRFont.regular(10))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 2)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.top, 14)
        }
        .background(FINDRColor.canvas)
        .fullScreenCover(item: $activeEditor, onDismiss: presentSaveConfirmationIfNeeded) { destination in
            switch destination {
            case .profile:
                MyProfileEditorView(profile: $profile) {
                    shouldShowProfileSaveConfirmation = true
                }
            }
        }
        .overlay {
            if isProfileSaveConfirmationVisible {
                profileSaveConfirmation
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isProfileSaveConfirmationVisible)
        .alert(selectedAction, isPresented: $showActionNotice) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("이 화면은 디자인 확인용 샘플입니다.")
        }
    }

    private var header: some View {
        FINDRPageHeader(
            title: "MY",
            trailingIcon: FINDRAssetName.settings,
            trailingLabel: isDarkMode ? "라이트 모드로 변경" : "다크 모드로 변경",
            action: { isDarkMode.toggle() }
        )
    }

    private var profileCard: some View {
        FINDRCard(padding: 16, hasShadow: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    FINDRProfileAvatar(photoPath: profile.profilePhotoPath, size: 60)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name)
                            .font(FINDRFont.bold(18))
                            .foregroundStyle(FINDRColor.primaryText)
                        Text(profileSummary)
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.secondaryText)
                        Button { activeEditor = .profile } label: {
                            HStack(spacing: 3) {
                                Text("프로필 수정")
                                FINDRIcon(name: FINDRAssetName.chevronRight, size: 12, tint: FINDRColor.brand)
                            }
                            .font(FINDRFont.medium(11))
                            .foregroundStyle(FINDRColor.brand)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("프로필 완성도")
                            .font(FINDRFont.medium(11))
                            .foregroundStyle(FINDRColor.secondaryText)
                        Spacer()
                        Text("70%")
                            .font(FINDRFont.bold(12))
                            .foregroundStyle(FINDRColor.brand)
                    }
                    FINDRProgressBar(progress: 0.7, color: FINDRColor.brandButton, height: 6)
                    Text("보유 조건을 추가하면 더 정확하게 추천해드려요")
                        .font(FINDRFont.regular(11))
                        .foregroundStyle(FINDRColor.tertiaryText)
                }
            }
        }
    }

    private func selectionCard(title: String, values: [String], addLabel: String) -> some View {
        FINDRCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(FINDRFont.bold(14))
                        .foregroundStyle(FINDRColor.primaryText)
                    Spacer()
                    Button { showAction("\(title) 수정") } label: {
                        HStack(spacing: 3) {
                            Text("수정")
                            FINDRIcon(name: FINDRAssetName.chevronRight, size: 13, tint: FINDRColor.tertiaryText)
                        }
                        .font(FINDRFont.regular(11))
                        .foregroundStyle(FINDRColor.tertiaryText)
                    }
                    .buttonStyle(.plain)
                }
                FlowTags(values: values, dashedAddLabel: addLabel) {
                    showAction("\(title) 추가")
                }
            }
        }
    }

    private var menuCard: some View {
        FINDRCard(padding: 10) {
            VStack(spacing: 0) {
                ForEach(Array(menuItems.enumerated()), id: \.offset) { index, item in
                    Button {
                        if item.0 == "알림 설정" {
                            onOpenNotificationSettings()
                        } else {
                            showAction(item.0)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            FINDRIcon(name: item.1, size: 18, tint: FINDRColor.secondaryText)
                            Text(item.0)
                                .font(FINDRFont.medium(14))
                                .foregroundStyle(FINDRColor.primaryText)
                            Spacer()
                            FINDRIcon(name: FINDRAssetName.chevronRight, size: 15, tint: FINDRColor.inactiveIcon)
                        }
                        .padding(.horizontal, 6)
                        .frame(height: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if index < menuItems.count - 1 {
                        FINDRColor.divider.frame(height: 1).padding(.leading, 30)
                    }
                }
            }
        }
    }

    private func showAction(_ action: String) {
        selectedAction = action
        showActionNotice = true
    }

    private func presentSaveConfirmationIfNeeded() {
        guard shouldShowProfileSaveConfirmation else { return }
        shouldShowProfileSaveConfirmation = false
        isProfileSaveConfirmationVisible = true
    }

    private var profileSaveConfirmation: some View {
        ZStack {
            Color.black.opacity(0.38)
                .ignoresSafeArea()
                .onTapGesture { isProfileSaveConfirmationVisible = false }

            VStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: FINDRAssetName.checkCircle, size: 42, tint: FINDRColor.success)
                Text("프로필이 저장되었어요")
                    .font(FINDRFont.bold(18))
                    .foregroundStyle(FINDRColor.primaryText)
                Text("변경된 조건으로 기회를 다시 계산했어요.\n새로 지원 가능한 기회가 2개 생겼어요.")
                    .font(FINDRFont.regular(13))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                FINDRButton(title: "확인") {
                    isProfileSaveConfirmationVisible = false
                }
                .padding(.top, FINDRSpacing.small)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 32)
        }
        .accessibilityAddTraits(.isModal)
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
    let dashedAddLabel: String
    let onAdd: () -> Void

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 6) {
                ForEach(values, id: \.self) { value in FINDRTag(title: value, tone: .brand, font: FINDRFont.regular(11)) }
                addButton
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    ForEach(values, id: \.self) { value in FINDRTag(title: value, tone: .neutral, font: FINDRFont.regular(11)) }
                }
                addButton
            }
        }
    }

    private var addButton: some View {
        Button(action: onAdd) {
            HStack(spacing: 4) {
                Text("+")
                Text(dashedAddLabel)
            }
            .font(FINDRFont.regular(11))
            .foregroundStyle(FINDRColor.secondaryText)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .overlay {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(FINDRColor.borderStrong, style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
            }
        }
        .buttonStyle(.plain)
    }
}
