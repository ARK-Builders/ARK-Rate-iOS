import Foundation

struct QuickCalculationDisplayModel: Equatable {

    // MARK: - Properties

    let id: UUID
    let elapsedTime: String
    let input: CurrencyDisplayModel
    let outputs: [CurrencyDisplayModel]

    // MARK: - Initialization

    init(
        id: UUID,
        calculatedDate: Date,
        input: CurrencyDisplayModel,
        outputs: [CurrencyDisplayModel]
    ) {
        self.id = id
        self.elapsedTime = calculatedDate.formattedElapsedTime
        self.input = input
        self.outputs = outputs
    }
}
