import Foundation

struct QuickCalculationGroup: Equatable {

    // MARK: - Properties

    let id: UUID
    let name: String
    let addedDate: Date
    let displayOrder: Int?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        addedDate: Date = Date(),
        displayOrder: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.addedDate = addedDate
        self.displayOrder = displayOrder
    }
}
