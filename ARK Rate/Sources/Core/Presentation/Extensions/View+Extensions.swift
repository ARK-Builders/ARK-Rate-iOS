import SwiftUI

extension View {

    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        self
            .opacity(hidden ? 0 : 1)
    }

    @ViewBuilder
    func isVisible(_ visible: Bool) -> some View {
        if visible {
            self
        }
    }

    @ViewBuilder
    func wiggle(isEnabled: Bool, amount: Double = 5) -> some View {
        if isEnabled {
            modifier(WiggleViewModifier(amount: amount))
        } else {
            self
        }
    }

    func tappableArea() -> some View {
        contentShape(Rectangle())
    }

    func onDropCompleted(perform action: @escaping ButtonAction) -> some View {
        onDrop(of: [.plainText], delegate: OutsideDropDelegate(action))
    }

    var hasExtendedTopArea: Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return false
        }
        return window.safeAreaInsets.top > 20
    }
}
