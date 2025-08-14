import SwiftUI

struct AddGroupModal: View {

    // MARK: - Properties

    @Binding var groupName: String
    let closeButtonAction: ButtonAction
    let cancelButtonAction: ButtonAction
    let confirmButtonAction: ButtonAction
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(ImageResource.circlesBackground)
                .aspectRatio(contentMode: .fit)
            content
        }
        .modifier(ModalBackgroundModifier())
        .padding(.horizontal, 16)
    }
}

// MARK: -

private extension AddGroupModal {

    var content: some View {
        VStack(spacing: Constants.verticalSpacing) {
            header
            textField
            buttons
        }
        .padding(.top, Constants.verticalSpacing)
        .padding(.horizontal, Constants.horizontalSpacing)
    }

    var header: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                groupIcon
                Spacer()
                PlainButton(
                    action: closeButtonAction,
                    label: {
                        Image.close
                            .font(.system(size: 18))
                            .foregroundColor(Color.foregroundQuarterary)
                    }
                )
            }
            Text(StringResource.createGroup.localized)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 18))
                .padding(.top, 10)
                .padding(.bottom, 2)
            Text(StringResource.createGroupDescription.localized)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterRegular(size: 14))
        }
    }

    var groupIcon: some View {
        Image(ImageResource.group)
            .adaptToColorScheme(colorScheme)
    }

    var textField: some View {
        InputView(
            title: StringResource.groupName.localized,
            placeholder: StringResource.createGroupPlaceholder.localized,
            input: $groupName
        )
        .padding(.bottom, 4)
    }

    var buttons: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: StringResource.confirm.localized,
                expandHorizontally: true,
                action: confirmButtonAction
            )
            .disabledWithOpacity(groupName.isEmpty)
            SecondaryButton(
                title: StringResource.cancel.localized,
                expandHorizontally: true,
                action: cancelButtonAction
            )
            .padding(.bottom, Constants.verticalSpacing)
        }
    }
}

// MARK: - Constants

private extension AddGroupModal {

    enum Constants {
        static let verticalSpacing: CGFloat = 20
        static let horizontalSpacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case createGroup = "create_group"
        case createGroupDescription = "create_group_description"
        case createGroupPlaceholder = "create_group_placeholder"
        case groupName = "group_name"
        case confirm
        case cancel

        var localized: String {
            String(localized: rawValue)
        }
    }
}
