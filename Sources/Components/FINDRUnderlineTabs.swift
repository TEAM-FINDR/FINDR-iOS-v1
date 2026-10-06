import SwiftUI

struct FINDRUnderlineTabs: View {
    let titles: [String]
    @Binding var selection: String
    var fontSize: CGFloat = 14
    var itemSpacing: CGFloat = 0
    var indicatorSpacing: CGFloat = 9
    var equalWidth: Bool = true
    var selectedTextColor: Color = FINDRColor.primaryText
    var unselectedTextColor: Color = FINDRColor.tertiaryText
    var selectedIndicatorColor: Color = FINDRColor.primaryText
    var unselectedIndicatorColor: Color = FINDRColor.divider
    var showsBottomDivider = false

    var body: some View {
        HStack(spacing: itemSpacing) {
            ForEach(titles, id: \.self) { title in
                Button {
                    selection = title
                } label: {
                    VStack(spacing: indicatorSpacing) {
                        Text(title)
                            .font(selection == title ? FINDRFont.bold(fontSize) : FINDRFont.regular(fontSize))
                            .foregroundStyle(selection == title ? selectedTextColor : unselectedTextColor)
                            .frame(maxWidth: equalWidth ? .infinity : nil)
                        Rectangle()
                            .fill(selection == title ? selectedIndicatorColor : unselectedIndicatorColor)
                            .frame(height: 2)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == title ? .isSelected : [])
            }

            if !equalWidth {
                Spacer(minLength: 0)
            }
        }
        .overlay(alignment: .bottom) {
            if showsBottomDivider {
                FINDRColor.divider
                    .frame(height: 1)
                    .offset(y: 1)
            }
        }
    }
}
