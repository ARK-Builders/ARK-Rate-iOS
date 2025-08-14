import SwiftUI

struct DisabledModifier: ViewModifier {

    // MARK: - Properties

    let disabled: Bool
    let opacity: Double

    // MARK: - Initialiaztion

    init(
        disabled: Bool,
        opacity: Double
    ) {
        self.disabled = disabled
        self.opacity = opacity
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .disabled(disabled)
            .opacity(!disabled ? 1 : opacity)
    }
}
