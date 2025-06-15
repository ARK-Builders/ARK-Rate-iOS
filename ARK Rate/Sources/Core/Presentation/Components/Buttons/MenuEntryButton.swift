import SwiftUI

struct MenuEntryButton: View {

    // MARK: - Properties

    let icon: Image
    let title: String
    let isDestructive: Bool
    let action: ButtonAction
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Initialization

    init(
        icon: Image,
        title: String,
        isDestructive: Bool = false,
        action: @escaping ButtonAction
    ) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Text(title)
                    if isDestructive {
                        icon
                    } else {
                        icon.adaptToColorScheme(colorScheme)
                    }
                }
            }
        )
    }
}
