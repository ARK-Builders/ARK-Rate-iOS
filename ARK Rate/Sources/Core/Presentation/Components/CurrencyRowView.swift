import SwiftUI

struct CurrencyRowView: View {

    // MARK: - Properties

    let code: String
    let name: String?
    let action: ButtonAction

    // MARK: - Initialization

    init(
        code: String,
        name: String? = nil,
        action: @escaping ButtonAction = {}
    ) {
        self.code = code
        self.name = name
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                LineDivider()
                HStack(spacing: 12) {
                    Image.image(code)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .modifier(CircleBorderModifier(backgroundColor: Constants.currencyBackgroundColor))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(code)
                            .foregroundColor(Color.textPrimary)
                            .font(Font.customInterMedium(size: 14))
                        if let name {
                            Text(name)
                                .foregroundColor(Color.textTertiary)
                                .font(Font.customInterRegular(size: 14))
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, Constants.verticalSpacing)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.horizontalSpacing)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Constants

private extension CurrencyRowView {

    enum Constants {
        static let verticalSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 24
        static let currencyBackgroundColor = Color.white
    }
}
