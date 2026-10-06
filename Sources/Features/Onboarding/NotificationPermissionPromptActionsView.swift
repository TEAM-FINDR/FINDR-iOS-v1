import SwiftUI

struct FINDRNotificationPermissionPromptActionsView: View {
    let onLater: () -> Void
    let onRequestNotifications: () -> Void

    var body: some View {
        HStack(spacing: FINDRSpacing.small) {
            Button(action: onLater) {
                Text("나중에")
                    .font(FINDRFont.bold(15))
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                            .stroke(FINDRColor.borderStrong, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)

            Button(action: onRequestNotifications) {
                Text("알림 받기")
                    .font(FINDRFont.bold(15))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(FINDRColor.brandButton, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}
