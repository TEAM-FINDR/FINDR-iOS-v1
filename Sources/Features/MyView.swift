import SwiftUI

struct MyView: View {
    @Binding var isDarkMode: Bool
    let completedAPathActions: Set<APathActionID>
    let onOpenNotificationSettings: () -> Void
    @State private var selectedAction = ""
    @State private var showActionNotice = false

    private let interests = ["개발", "디자인", "창업"]
    private var conditions: [String] {
        var values = ["정보처리 관련 자격증 1개", "교육 이수 2개", "프로젝트 1개"]
        if completedAPathActions.contains(.portfolio) {
            values.insert("포트폴리오", at: 0)
        }
        return values
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
                selectionCard(title: "관심 분야", values: interests, addLabel: "추가")
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
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: 0x7DA5FF), Color(hex: 0x2B62E9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                        .overlay { FINDRIcon(name: FINDRAssetName.profile, size: 30, tint: .white) }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("이시우")
                            .font(FINDRFont.bold(18))
                            .foregroundStyle(FINDRColor.primaryText)
                        Text("17세 · 광주 · 고등학생")
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.secondaryText)
                        Button { showAction("프로필 수정") } label: {
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
