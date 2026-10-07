import SwiftUI

struct FINDROnboardingIntroCopyView: View {
    let content: FINDROnboardingIntroPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            VStack(alignment: .leading, spacing: -4) {
                ForEach(content.title.split(separator: "\n").map(String.init), id: \.self) { line in
                    Text(line)
                        .font(FINDRFont.titleLarge)
                        .tracking(-0.52)
                        .foregroundStyle(Color(hex: 0x0E1A3A))
                }
            }
            .fixedSize(horizontal: false, vertical: true)

            Text(content.description)
                .font(FINDRFont.regular(15))
                .tracking(-0.3)
                .lineSpacing(-2)
                .foregroundStyle(FINDRColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
