import SwiftUI

struct HideKeyboardModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                },
                including: .all
            )
    }
}
