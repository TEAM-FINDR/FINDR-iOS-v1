import SwiftUI

struct FINDRNotificationPermissionPromptView: View {
    let onLater: () -> Void
    let onRequestNotifications: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.42)
                .ignoresSafeArea()
                .onTapGesture {}
                .accessibilityHidden(true)

            VStack {
                Spacer(minLength: 0)
                VStack(spacing: FINDRSpacing.medium) {
                    FINDRNotificationPermissionPromptHeaderView()
                    FINDRNotificationPermissionPromptActionsView(
                        onLater: onLater,
                        onRequestNotifications: onRequestNotifications
                    )
                    .padding(.top, FINDRSpacing.small)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.white, in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
                .padding(.horizontal, 36)
                Spacer(minLength: 0)
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}
