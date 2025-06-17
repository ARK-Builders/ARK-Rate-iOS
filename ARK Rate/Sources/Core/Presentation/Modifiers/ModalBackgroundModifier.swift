import SwiftUI

struct ModalBackgroundModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .background(Color.backgroundPrimary)
            .cornerRadius(12)
    }
}
