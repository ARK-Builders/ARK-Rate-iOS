import Foundation

struct GroupDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: UUID
    let name: String
    let displayOrder: Int?

    // MARK: - Initialization

    init(
        id: UUID,
        name: String,
        displayOrder: Int?
    ) {
        self.id = id
        self.name = name
        self.displayOrder = displayOrder
    }
}
