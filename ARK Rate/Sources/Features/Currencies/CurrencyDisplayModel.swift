import Foundation

struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String
    let amount: String

    var name: String {
        String(localized: String.LocalizationValue(id))
    }

    var formattedAmount: String {
        "\(amount) \(id)"
    }

    // MARK: - Initialization

    init(
        from currency: Currency,
        amount: String = ""
    ) {
        self.id = currency.code
        self.amount = amount
    }
}
