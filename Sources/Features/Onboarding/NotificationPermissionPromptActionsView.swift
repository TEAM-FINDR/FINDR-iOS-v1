import SwiftUI

struct FINDRNotificationPermissionPromptActionsView: View {
    let onLater: () -> Void
    let onRequestNotifications: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onLater) {
                Text("나중에")
                    .font(FINDRFont.bold(15))
                    .foregroundStyle(FINDRColor.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(FINDRColor.borderStrong, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)

            Button(action: onRequestNotifications) {
                Text("알림 받기")
                    .font(FINDRFont.bold(15))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(FINDRColor.brandButton, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}
