import Foundation
import SwiftData

@Model
final class QuickCalculationGroupModel {

    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var name: String
    var addedDate: Date
    var displayOrder: Int?

    @Relationship(deleteRule: .cascade) var calculations: [QuickCalculationModel]

    // MARK: - Initialization

    init(
        id: UUID,
        name: String,
        addedDate: Date,
        displayOrder: Int?
    ) {
        self.id = id
        self.name = name
        self.addedDate = addedDate
        self.displayOrder = displayOrder
        self.calculations = []
    }
}
