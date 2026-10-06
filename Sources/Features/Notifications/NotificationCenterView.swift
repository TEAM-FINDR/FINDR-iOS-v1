import SwiftUI

struct NotificationCenterView: View {
    @Binding var notifications: [FINDRNotification]
    let onOpenSettings: () -> Void
    let onSelectDestination: (FINDRNotificationDestination) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navigationHeader

            if notifications.isEmpty {
                emptyState
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.bottom, 60)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                        ForEach(FINDRNotificationGroup.allCases) { group in
                            notificationSection(group)
                        }
                    }
                    .padding(.bottom, FINDRSpacing.large)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.surface)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var navigationHeader: some View {
        FINDRBackNavigationHeader(
            title: "알림",
            onBack: { dismiss() },
            trailingIconName: FINDRAssetName.settings,
            trailingAccessibilityLabel: "알림 설정",
            onTrailing: onOpenSettings
        )
    }

    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: FINDRSpacing.medium) {
            FINDRIcon(name: FINDRAssetName.bell, size: 32, tint: FINDRColor.secondaryText)
                .frame(width: 72, height: 72)
                .background(FINDRColor.subtle, in: Circle())

            VStack(spacing: FINDRSpacing.xSmall) {
                Text("아직 받은 알림이 없어요")
                    .font(FINDRFont.titleSmall)
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.primaryText)
                    .multilineTextAlignment(.center)

                Text("새로운 기회가 열리거나 마감이 다가오면 가장 먼저 알려드릴게요.")
                    .font(FINDRFont.bodySmall)
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, FINDRSpacing.xLarge)
    }

    @ViewBuilder
    private func notificationSection(_ group: FINDRNotificationGroup) -> some View {
        let groupedNotifications = notifications.filter { $0.group == group }
        if !groupedNotifications.isEmpty {
            VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                Text(group.rawValue)
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(FINDRColor.tertiaryText)
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.bottom, FINDRSpacing.small)

                ForEach(groupedNotifications) { notification in
                    notificationRow(notification)
                }
            }
            .padding(.top, FINDRSpacing.large)
        }
    }

    private func notificationRow(_ notification: FINDRNotification) -> some View {
        Button {
            markAsRead(notification.id)
            onSelectDestination(notification.destination)
        } label: {
            HStack(alignment: .top, spacing: FINDRSpacing.medium) {
                FINDRIcon(name: notification.kind.iconName, size: 20, tint: notification.kind.iconTint)
                    .frame(width: 40, height: 40)
                    .background(notification.kind.iconBackground, in: Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(notification.title)
                        .font(FINDRFont.bold(14))
                        .kerning(-0.28)
                        .foregroundStyle(FINDRColor.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(notification.message)
                        .font(FINDRFont.bodySmall)
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(notification.time)
                        .font(FINDRFont.caption)
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.tertiaryText)
                        .padding(.top, 1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Circle()
                    .fill(notification.isUnread ? FINDRColor.brandButton : .clear)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, FINDRSpacing.screen)
            .padding(.vertical, FINDRSpacing.large)
            .background(notification.isUnread ? FINDRColor.brandTint : FINDRColor.surface)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("열려서 읽음으로 표시됩니다")
    }

    private func markAsRead(_ id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].markAsRead()
    }
}
