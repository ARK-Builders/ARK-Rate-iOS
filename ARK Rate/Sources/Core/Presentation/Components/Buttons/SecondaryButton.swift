import SwiftUI

struct SecondaryButton: View {

    // MARK: - Properties

    let title: String
    let icon: Image?
    let disabled: Bool
    let expandHorizontally: Bool
    let action: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        icon: Image? = nil,
        disabled: Bool = false,
        expandHorizontally: Bool = false,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.icon = icon
        self.disabled = disabled
        self.expandHorizontally = expandHorizontally
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        ActionButton(
            title: title,
            icon: icon,
            style: .secondary,
            disabled: disabled,
            expandHorizontally: expandHorizontally,
            action: action
        )
        .modifier(RoundedBorderModifier())
    }
}
