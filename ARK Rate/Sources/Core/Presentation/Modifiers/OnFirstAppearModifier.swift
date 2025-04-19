import SwiftUI

struct OnFirstAppearModifier: ViewModifier {

    // MARK: - Properties

    @State private var didAppear = false
    let action: ButtonAction

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                action()
            }
    }
}

// MARK: -

extension View {

    func onFirstAppear(_ action: @escaping ButtonAction) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}
