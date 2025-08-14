import SwiftUI

struct CircleBorderModifier: ViewModifier {

    // MARK: - Properties

    let color: Color
    let backgroundColor: Color
    let lineWidth: CGFloat

    // MARK: - Initialization

    init(
        color: Color = Color.borderPrimary,
        backgroundColor: Color = Color.backgroundTertiary,
        lineWidth: CGFloat = 1
    ) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .background(Circle().fill(backgroundColor))
            .overlay(
                Circle()
                    .strokeBorder(color, lineWidth: lineWidth)
                    .allowsHitTesting(false)
            )
    }
}
