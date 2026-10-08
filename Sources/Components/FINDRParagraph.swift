import SwiftUI
import UIKit

/// Preserves the design line box and allows Korean to wrap at character boundaries.
struct FINDRParagraph: UIViewRepresentable {
    let text: String
    var alignment: NSTextAlignment = .left
    var fontSize: CGFloat = 13
    var lineHeight: CGFloat = 18
    var kerning: CGFloat = -0.26
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    func updateUIView(_ label: UILabel, context: Context) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineBreakMode = .byCharWrapping
        paragraph.minimumLineHeight = lineHeight
        paragraph.maximumLineHeight = lineHeight
        label.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont(name: "NotoSansKR-Thin_Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor(FINDRColor.secondaryText),
            .kern: kerning,
            .paragraphStyle: paragraph
        ])
    }
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        let measured = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        // Returning intrinsic text width here causes SwiftUI to reflow the paragraph.
        return CGSize(width: width, height: measured.height)
    }
}
