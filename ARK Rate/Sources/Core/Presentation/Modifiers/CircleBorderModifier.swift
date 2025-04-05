import SwiftUI

struct CircleBorderModifier: ViewModifier {

    // MARK: - Properties

    let color: Color
    let backgroundColor: Color

    // MARK: - Initialization

    init(
        color: Color = Color.borderPrimary,
        backgroundColor: Color = Color.backgroundTertiary
    ) {
        self.color = color
        self.backgroundColor = backgroundColor
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(backgroundColor)
            )
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 1)
            )
    }
}
