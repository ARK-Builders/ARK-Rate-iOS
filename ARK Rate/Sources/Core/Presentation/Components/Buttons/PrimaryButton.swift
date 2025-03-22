import SwiftUI

struct PrimaryButton: View {

    // MARK: - Properties

    let title: String
    let icon: Image?
    let action: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        icon: Image? = nil,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        ActionButton(
            title: title,
            icon: icon,
            style: .primary,
            action: action
        )
    }
}
