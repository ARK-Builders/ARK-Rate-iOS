import Foundation

struct QuickCalculationDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: UUID
    let pinned: Bool
    let elapsedTime: String
    let input: CurrencyDisplayModel
    let outputs: [CurrencyDisplayModel]

    var togglePinnedTitle: String {
        !pinned ? StringResource.pin.localized : StringResource.unpin.localized
    }

    // MARK: - Initialization

    init(
        id: UUID,
        pinnedDate: Date?,
        calculatedDate: Date,
        input: CurrencyDisplayModel,
        outputs: [CurrencyDisplayModel]
    ) {
        self.id = id
        self.pinned = pinnedDate != nil
        self.elapsedTime = calculatedDate.formattedElapsedTime
        self.input = input
        self.outputs = outputs
    }
}

// MARK: - Constants

private extension QuickCalculationDisplayModel {

    enum StringResource: String.LocalizationValue {
        case pin
        case unpin

        var localized: String {
            String(localized: rawValue)
        }
    }
}
