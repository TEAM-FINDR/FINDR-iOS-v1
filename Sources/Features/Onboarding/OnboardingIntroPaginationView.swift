import SwiftUI

struct FINDROnboardingIntroPaginationView: View {
    let page: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { index in
                Capsule()
                    .fill(index == page ? FINDRColor.brandButton : FINDRColor.track)
                    .frame(width: index == page ? 18 : 6, height: 6)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("온보딩 \(page)/3")
    }
}
