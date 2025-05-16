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
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .padding(.horizontal, Constants.horizontalSpacing)
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
                Button(
                    action: closeButtonAction,
                    label: Image.close
                        .font(.system(size: 18))
                        .foregroundColor(Color.foregroundQuarterary)
                        .contentShape(Rectangle())
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

    @ViewBuilder
    var groupIcon: some View {
        if colorScheme == .dark {
            Image(ImageResource.group)
                .renderingMode(.template)
                .foregroundColor(Color.white)
                .aspectRatio(contentMode: .fit)
        } else {
            Image(ImageResource.group)
                .aspectRatio(contentMode: .fit)
        }
    }

    var textField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(StringResource.groupName.localized)
                .foregroundColor(Color.textSecondary)
                .font(Font.customInterMedium(size: 14))
            ZStack {
                TextField(StringResource.createGroupPlaceholder.localized, text: $groupName)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.textPrimary)
                    .font(Font.customInterRegular(size: 16))
                    .padding(.horizontal, 14)
            }
            .frame(height: Constants.textFieldHeight)
            .modifier(RoundedBorderModifier())
        }
        .padding(.bottom, 4)
    }

    var buttons: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: StringResource.confirm.localized,
                expandHorizontally: true,
                action: confirmButtonAction
            )
            .modifier(DisabledModifier(disabled: groupName.isEmpty))
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
        static let textFieldHeight: CGFloat = 48
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
