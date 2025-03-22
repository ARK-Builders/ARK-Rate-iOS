import SwiftUI

struct ActionButton: View {

    enum Style {
        case primary
        case secondary

        var foregroundColor: Color {
            switch self {
            case .primary: Color.white
            case .secondary: Color.textSecondary
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary: Color.brandSolid
            case .secondary: Color.clear
            }
        }
    }

    // MARK: - Properties

    let title: String
    let icon: Image?
    let style: Style
    let action: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        icon: Image? = nil,
        style: Style,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    icon
                        .renderingMode(.template)
                        .foregroundColor(style.foregroundColor)
                }
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(Font.customInterSemiBold(size: 16))
                    .foregroundColor(style.foregroundColor)
            }
        }
        .padding(.vertical, Constants.verticalSpacing)
        .padding(.horizontal, Constants.horizontalSpacing)
        .background(style.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

// MARK: - Constants

private extension ActionButton {

    enum Constants {
        static let verticalSpacing: CGFloat = 10
        static let horizontalSpacing: CGFloat = 14
    }
}
