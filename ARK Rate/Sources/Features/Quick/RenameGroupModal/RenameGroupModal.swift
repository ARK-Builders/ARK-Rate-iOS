import SwiftUI

struct RenameGroupModal: View {

    // MARK: - Properties

    @Binding var groupName: String
    let closeButtonAction: ButtonAction
    let saveButtonAction: ButtonAction

    // MARK: - Body

    var body: some View {
        VStack {
            content
        }
        .modifier(ModalBackgroundModifier())
    }
}

// MARK: -

private extension RenameGroupModal {

    var content: some View {
        VStack(spacing: 24) {
            header
            InputView(
                title: StringResource.groupName.localized,
                placeholder: StringResource.createGroupPlaceholder.localized,
                input: $groupName
            )
            PrimaryButton(
                title: StringResource.save.localized,
                expandHorizontally: true,
                action: saveButtonAction
            )
        }
        .padding(.vertical, Constants.verticalSpacing)
        .padding(.horizontal, Constants.horizontalSpacing)
    }

    var header: some View {
        HStack {
            Text(StringResource.renameGroup.localized)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 18))
            Spacer()
            Button(
                action: closeButtonAction,
                label: Image.close
                    .font(.system(size: 18))
                    .foregroundColor(Color.foregroundQuarterary)
                    .tappableArea()
            )
        }
    }
}

// MARK: - Constants

private extension RenameGroupModal {

    enum Constants {
        static let verticalSpacing: CGFloat = 20
        static let horizontalSpacing: CGFloat = 16
        static let textFieldHeight: CGFloat = 48
    }

    enum StringResource: String.LocalizationValue {
        case save
        case groupName = "group_name"
        case renameGroup = "rename_group"
        case createGroupPlaceholder = "create_group_placeholder"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
