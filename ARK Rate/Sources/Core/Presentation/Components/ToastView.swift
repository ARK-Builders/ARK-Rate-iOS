import SwiftUI

struct ToastView: View {

    // MARK: - Properties

    let icon: Image
    let title: String
    let subtitle: String
    let closeButtonAction: ButtonAction
    let actionButtonConfiguration: ButtonConfiguration?

    // MARK: - Initialization

    init(
        icon: Image,
        title: String,
        subtitle: String,
        closeButtonAction: @escaping ButtonAction,
        actionButtonConfiguration: ButtonConfiguration?
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.closeButtonAction = closeButtonAction
        self.actionButtonConfiguration = actionButtonConfiguration
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            header
            content
            actionButton
        }
        .padding(Constants.spacing)
        .background(Color.backgroundPrimary)
        .modifier(
            RoundedBorderModifier(
                lineWidth: 2,
                cornerRadius: 12
            )
        )
    }
}

// MARK: -

private extension ToastView {

    var header: some View {
        HStack {
            icon
                .resizable()
                .frame(width: Constants.iconSize, height: Constants.iconSize)
                .padding(.leading, -Constants.spacing / 2)
            Spacer()
            Button(
                action: closeButtonAction,
                label: Image.close
                    .font(.system(size: 18))
                    .foregroundColor(Color.foregroundQuarterary)
                    .contentShape(Rectangle())
                    .padding(.bottom, Constants.spacing)
                    .padding(.leading, Constants.spacing)
            )
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 14))
            Text(subtitle)
                .foregroundColor(Color.textSecondary)
                .font(Font.customInterRegular(size: 14))
        }
    }

    @ViewBuilder
    var actionButton: some View {
        if let (title, action) = actionButtonConfiguration {
            Button(
                action: action,
                label: Text(title)
                    .foregroundColor(Color.brandSolid)
                    .font(Font.customInterSemiBold(size: 14))
            )
        }
    }
}

// MARK: - Constants

private extension ToastView {

    enum Constants {
        static let spacing: CGFloat = 12
        static let iconSize: CGFloat = 38
    }
}
