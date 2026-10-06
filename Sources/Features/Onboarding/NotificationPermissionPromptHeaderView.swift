import SwiftUI

struct FINDRNotificationPermissionPromptHeaderView: View {
    var body: some View {
        VStack(spacing: FINDRSpacing.medium) {
            Circle()
                .fill(FINDRColor.brandSubtle)
                .frame(width: 48, height: 48)
                .overlay {
                    FINDRIcon(name: FINDRAssetName.bell, size: 24, tint: FINDRColor.brandButton)
                }

            Text("마감 알림을 받아보세요")
                .font(FINDRFont.bold(16))
                .foregroundStyle(FINDRColor.primaryText)
                .multilineTextAlignment(.center)

            Text("새로운 기회가 열리거나 저장한 기회의 마감이 다가오면 알려드려요.")
                .font(FINDRFont.regular(13))
                .tracking(-0.26)
                .foregroundStyle(FINDRColor.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
