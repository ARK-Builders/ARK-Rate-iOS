import Foundation

struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String
    let amount: Decimal
    let disabled: Bool

    var name: String {
        String(localized: String.LocalizationValue(id))
    }

    var formattedAmount: String {
        "\(amount.formattedRate) \(id)"
    }

    // MARK: - Initialization

    init(
        code: String,
        amount: Decimal = 0,
        disabled: Bool = false
    ) {
        self.id = code
        self.amount = amount
        self.disabled = disabled
    }
}
