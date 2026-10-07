import SwiftUI
import UIKit

struct FINDREmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(icon).resizable().frame(width: 32, height: 32)
                .frame(width: 72, height: 72)
                .background(FINDRColor.subtle, in: Circle())
                .accessibilityHidden(true)
            Text(title).font(FINDRFont.bold(17)).kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText).frame(height: 24)
            FINDREmptyStateMessage(text: message)
                .frame(maxWidth: .infinity)
            Button(action: action) {
                Text(actionTitle).font(FINDRFont.bold(15)).kerning(-0.3)
                    .foregroundStyle(.white).frame(width: 180, height: 54)
                    .background(FINDRColor.brandButton, in: RoundedRectangle(cornerRadius: 12))
            }.buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

/// Figma wraps Korean at character boundaries; UILabel provides the matching behavior.
private struct FINDREmptyStateMessage: UIViewRepresentable {
    let text: String
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    func updateUIView(_ label: UILabel, context: Context) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byCharWrapping
        paragraph.minimumLineHeight = 18.2
        paragraph.maximumLineHeight = 18.2
        label.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont(name: "NotoSansKR-Thin_Regular", size: 13) ?? UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(FINDRColor.secondaryText),
            .kern: -0.26,
            .paragraphStyle: paragraph
        ])
    }
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }
}
