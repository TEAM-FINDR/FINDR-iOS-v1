import SwiftUI

struct FINDROnboardingSocialLoginButton: View {
    enum Provider {
        case apple
        case kakao
        case google

        var title: String {
            switch self {
            case .apple: "Apple로 계속하기"
            case .kakao: "카카오로 계속하기"
            case .google: "Google로 계속하기"
            }
        }

        var foreground: Color {
            switch self {
            case .apple: .white
            case .kakao: Color(hex: 0x191919)
            case .google: FINDRColor.primaryText
            }
        }

        var background: Color {
            switch self {
            case .apple: Color(hex: 0x0B0B0F)
            case .kakao: Color(hex: 0xFEE500)
            case .google: .white
            }
        }

        var iconName: String? {
            switch self {
            case .apple: FINDRAssetName.appleLogo
            case .kakao: FINDRAssetName.kakaoLogo
            case .google: nil
            }
        }
    }

    let provider: Provider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FINDRSpacing.small) {
                providerIcon

                Text(provider.title)
                    .font(FINDRFont.bold(15))
                    .tracking(-0.3)
                    .foregroundStyle(provider.foreground)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(provider.background, in: RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous))
            .overlay {
                if provider == .google {
                    RoundedRectangle(cornerRadius: FINDRRadius.medium, style: .continuous)
                        .stroke(FINDRColor.borderStrong, lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityHint("디자인 시제품에서 프로필 입력 단계로 이동합니다.")
    }

    @ViewBuilder
    private var providerIcon: some View {
        if let iconName = provider.iconName {
            FINDRIcon(name: iconName, size: 20, tint: provider.foreground, usesTemplate: false)
        } else {
            Text("G")
                .font(.system(size: 18, weight: .black))
                .foregroundStyle(FINDRColor.brandButton)
        }
    }
}

extension FINDROnboardingSocialLoginButton.Provider: Equatable {}
