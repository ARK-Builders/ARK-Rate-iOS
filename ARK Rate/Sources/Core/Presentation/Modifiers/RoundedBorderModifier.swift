import SwiftUI

struct RoundedBorderModifier: ViewModifier {

    // MARK: - Properties

    let color: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    // MARK: - Initialization

    init(
        color: Color = Color.borderPrimary,
        lineWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
