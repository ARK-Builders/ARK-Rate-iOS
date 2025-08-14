import SwiftUI

struct ActionButton: View {

    enum Style {
        case primary
        case secondary
        case custom(foregroundColor: Color, backgroundColor: Color)

        var foregroundColor: Color {
            switch self {
            case .primary: Color.white
            case .secondary: Color.textSecondary
            case .custom(let foregroundColor, _): foregroundColor
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary: Color.brandSolid
            case .secondary: Color.clear
            case .custom(_, let backgroundColor): backgroundColor
            }
        }
    }

    // MARK: - Properties

    let title: String
    let icon: Image?
    let style: Style
    let disabled: Bool
    let expandHorizontally: Bool
    let action: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        icon: Image? = nil,
        style: Style,
        disabled: Bool = false,
        expandHorizontally: Bool = false,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.disabled = disabled
        self.expandHorizontally = expandHorizontally
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        PlainButton(action: action) {
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
            .frame(height: Constants.height)
            .frame(maxWidth: expandHorizontally ? .infinity : nil)
        }
        .padding(.horizontal, Constants.horizontalSpacing)
        .background(style.backgroundColor, in: RoundedRectangle(cornerRadius: 8))
        .disabledWithOpacity(disabled)
    }
}

// MARK: - Constants

private extension ActionButton {

    enum Constants {
        static let height: CGFloat = 44
        static let horizontalSpacing: CGFloat = 16
    }
}
