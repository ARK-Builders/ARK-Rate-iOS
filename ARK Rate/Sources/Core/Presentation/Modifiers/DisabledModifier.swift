import SwiftUI

struct DisabledModifier: ViewModifier {

    // MARK: - Properties

    let disabled: Bool
    let disabledOpacity: Double

    // MARK: - Initialiaztion

    init(
        disabled: Bool,
        disabledOpacity: Double = 0.5) {
        self.disabled = disabled
        self.disabledOpacity = disabledOpacity
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .disabled(disabled)
            .opacity(!disabled ? 1 : disabledOpacity)
    }
}
