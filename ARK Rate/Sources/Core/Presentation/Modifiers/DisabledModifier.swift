import SwiftUI

struct DisabledModifier: ViewModifier {

    // MARK: - Properties

    let disabled: Bool

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .disabled(disabled)
            .opacity(!disabled ? 1 : 0.5)
    }
}
