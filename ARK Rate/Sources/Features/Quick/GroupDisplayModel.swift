import Foundation

struct GroupDisplayModel: Reorderable {

    // MARK: - Properties

    let id: UUID
    let displayOrder: Int?
    let displayName: String

    // MARK: - Initialization

    init(id: UUID, name: String, displayOrder: Int?) {
        self.id = id
        self.displayName = if !Constants.defaultGroupKeys.contains(name) {
            name
        } else {
            NSLocalizedString(name, comment: "")
        }
        self.displayOrder = displayOrder
    }
}

// MARK: - Constants

private extension GroupDisplayModel {

    enum Constants {
        static let defaultGroupKeys: Set<String> = [QuickCalculationGroup.defaultGroupName]
    }
}
