import SwiftUI

struct GroupMenuView: View {

    // MARK: - Properties

    @Binding var groupName: String
    let groups: [GroupDisplayModel]
    let addGroupAction: ButtonAction
    let onSelectedGroupAction: ActionHandler<GroupDisplayModel>

    // MARK: - Body

    var body: some View {
        Menu {
            newGroupItem
            groupItems
        } label: {
            HStack(spacing: Constants.itemSpacing) {
                Image.folder
                    .foregroundColor(Color.foregroundQuarterary)
                Text(groupName)
                    .foregroundColor(Color.textPrimary)
                    .font(Font.customInterRegular(size: 16))
                Spacer()
                Image.chevronDown
                    .foregroundColor(Color.grayNeutral)
            }
            .padding(.vertical, Constants.verticalSpacing)
            .padding(.horizontal, Constants.horizontalSpacing)
            .modifier(RoundedBorderModifier())
        }
    }
}

// MARK: -

private extension GroupMenuView {

    var newGroupItem: some View {
        Button(
            action: addGroupAction,
            label: {
                HStack(spacing: Constants.itemSpacing) {
                    Image.folderBadgePlus
                        .foregroundColor(Color.foregroundQuarterary)
                    Text(StringResource.newGroup.localized)
                        .foregroundColor(Color.textPrimary)
                        .font(Font.customInterMedium(size: 16))
                }
            }
        )
    }

    var groupItems: some View {
        ForEach(groups, id: \.id) { group in
            Button(
                action: {
                    groupName = group.displayName
                    onSelectedGroupAction(group)
                },
                label: {
                    Text(group.displayName)
                        .foregroundColor(Color.textPrimary)
                        .font(Font.customInterMedium(size: 16))
                }
            )
        }
    }
}

// MARK: - Constants

private extension GroupMenuView {

    enum Constants {
        static let itemSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 12
        static let horizontalSpacing: CGFloat = 14
    }

    enum StringResource: String.LocalizationValue {
        case addGroup = "add_group"
        case newGroup = "new_group"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
