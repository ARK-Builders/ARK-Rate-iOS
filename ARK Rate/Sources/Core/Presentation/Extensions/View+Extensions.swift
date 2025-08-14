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
    func isDisabled(_ disabled: Bool) -> some View {
        if disabled {
            self
                .highPriorityGesture(DragGesture(), including: .all)
        } else {
            self
        }
    }

    @ViewBuilder
    func wiggle(isEnabled: Bool, amount: Double = 3) -> some View {
        if isEnabled {
            modifier(WiggleViewModifier(amount: amount))
        } else {
            self
        }
    }

    func dismissKeyboardOnTap() -> some View {
        modifier(HideKeyboardModifier())
    }

    func expandHitArea() -> some View {
        contentShape(Rectangle())
    }

    func disabledWithOpacity(_ disabled: Bool, opacity: CGFloat = 0.5) -> some View {
        modifier(DisabledModifier(disabled: disabled, opacity: opacity))
    }

    func roundedBorder(color: Color = Color.borderPrimary, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }

    // MARK: - Gestures

    func onDropCompleted(perform action: @escaping ButtonAction) -> some View {
        onDrop(of: [.plainText], delegate: OutsideDropDelegate(action))
    }

    // MARK: - List

    func listRowPlainStyle() -> some View {
        modifier(PlainListRowModifier())
    }

    // MARK: - Computed Properties

    var hasExtendedTopArea: Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return false
        }
        return window.safeAreaInsets.top > 20
    }
}
