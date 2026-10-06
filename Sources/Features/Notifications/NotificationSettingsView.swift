import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("FINDR.notifications.newOpportunities") private var newOpportunitiesEnabled = true
    @AppStorage("FINDR.notifications.eligibleOpportunities") private var eligibleOpportunitiesEnabled = true
    @AppStorage("FINDR.notifications.savedOpportunityChanges") private var savedOpportunityChangesEnabled = true
    @AppStorage("FINDR.notifications.deadlineD7") private var deadlineD7Enabled = true
    @AppStorage("FINDR.notifications.deadlineD3") private var deadlineD3Enabled = true
    @AppStorage("FINDR.notifications.deadlineD1") private var deadlineD1Enabled = false
    @AppStorage("FINDR.notifications.eventsAndBenefits") private var eventsAndBenefitsEnabled = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "알림 설정", onBack: { dismiss() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.section) {
                    opportunitySettings
                    deadlineSettings
                    otherSettings

                    Text("기기 설정에서 알림이 꺼져 있으면 알림을 받을 수 없어요.")
                        .font(FINDRFont.label)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, -FINDRSpacing.small)
                        .padding(.bottom, FINDRSpacing.large)
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.canvas)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var opportunitySettings: some View {
        settingGroup(title: "기회 알림") {
            VStack(spacing: 0) {
                NotificationSettingRow(
                    title: "새로운 기회",
                    iconName: FINDRAssetName.notificationSparkles,
                    isEnabled: $newOpportunitiesEnabled
                )
                NotificationSettingRow(
                    title: "지원 가능해진 기회",
                    iconName: FINDRAssetName.unlock,
                    isEnabled: $eligibleOpportunitiesEnabled
                )
                NotificationSettingRow(
                    title: "저장한 기회 변경",
                    iconName: FINDRAssetName.notificationEdit,
                    isEnabled: $savedOpportunityChangesEnabled
                )
            }
        }
    }

    private var deadlineSettings: some View {
        settingGroup(title: "마감 알림") {
            VStack(spacing: 0) {
                NotificationSettingRow(
                    title: "마감 D-7",
                    iconName: FINDRAssetName.calendar,
                    isEnabled: $deadlineD7Enabled
                )
                NotificationSettingRow(
                    title: "마감 D-3",
                    iconName: FINDRAssetName.calendar,
                    isEnabled: $deadlineD3Enabled
                )
                NotificationSettingRow(
                    title: "마감 D-1",
                    iconName: FINDRAssetName.clock,
                    isEnabled: $deadlineD1Enabled
                )
            }
        }
    }

    private var otherSettings: some View {
        settingGroup(title: "기타") {
            NotificationSettingRow(
                title: "이벤트·혜택 소식",
                iconName: FINDRAssetName.notificationMail,
                isEnabled: $eventsAndBenefitsEnabled
            )
        }
    }

    private func settingGroup<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            Text(title)
                .font(FINDRFont.bold(12))
                .foregroundStyle(FINDRColor.tertiaryText)

            content()
                .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
        }
    }
}

private struct NotificationSettingRow: View {
    let title: String
    let iconName: String
    @Binding var isEnabled: Bool

    var body: some View {
        Toggle(isOn: $isEnabled) {
            HStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: iconName, size: 20, tint: FINDRColor.secondaryText)
                Text(title)
                    .font(FINDRFont.medium(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
            }
        }
        .tint(FINDRColor.brandButton)
        .padding(.horizontal, FINDRSpacing.large)
        .padding(.vertical, FINDRSpacing.medium)
        .accessibilityIdentifier("notification-setting-\(title)")
    }
}
