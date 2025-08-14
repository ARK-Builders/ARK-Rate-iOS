import SwiftUI

struct RoundedBorderModifier: ViewModifier {

    // MARK: - Properties

    let color: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(color, lineWidth: lineWidth)
                    .allowsHitTesting(false)
            )
    }
}
