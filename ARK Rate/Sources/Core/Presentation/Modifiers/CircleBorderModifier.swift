import SwiftUI

struct CircleBorderModifier: ViewModifier {

    // MARK: - Properties

    let width: CGFloat
    let color: Color
    let backgroundColor: Color

    // MARK: - Initialization

    init(
        width: CGFloat = 1,
        color: Color = Color.borderSecondary,
        backgroundColor: Color = Color.backgroundTertiary
    ) {
        self.width = width
        self.color = color
        self.backgroundColor = backgroundColor
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(backgroundColor)
            )
            .overlay(
                Circle()
                    .stroke(color, lineWidth: width)
            )
    }
}
