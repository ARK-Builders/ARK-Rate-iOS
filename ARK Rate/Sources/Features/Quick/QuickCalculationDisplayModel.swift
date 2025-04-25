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

    var description: String {
        let output: String
        switch outputs.count {
        case 1:
            output = outputs.first!.id
        case 2:
            output = "\(outputs.first!.id) \(StringResource.and.localized) \(outputs.last!.id)"
        default:
            let allButLast = outputs.dropLast().map(\.id).joined(separator: ", ")
            output = "\(allButLast), \(StringResource.and.localized) \(outputs.last!.id)"
        }
        return "\(input.id) \(StringResource.to.localized) \(output)"
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
        case to
        case and

        var localized: String {
            String(localized: rawValue)
        }
    }
}
