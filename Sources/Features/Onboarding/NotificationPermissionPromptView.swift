import SwiftUI

struct FINDRNotificationPermissionPromptView: View {
    let onLater: () -> Void
    let onRequestNotifications: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {}
                .accessibilityHidden(true)

            VStack(spacing: 16) {
                FINDRNotificationPermissionPromptHeaderView()
                FINDRNotificationPermissionPromptActionsView(
                    onLater: onLater,
                    onRequestNotifications: onRequestNotifications
                )
            }
            .padding(24)
            .frame(width: 320)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .accessibilityAddTraits(.isModal)
    }
}
