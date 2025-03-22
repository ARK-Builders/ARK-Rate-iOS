import SwiftUI

struct RoundedBorderModifier: ViewModifier {

    // MARK: - Properties

    let color: Color

    // MARK: - Initialization

    init(color: Color = Color.borderPrimary) {
        self.color = color
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
    }
}
