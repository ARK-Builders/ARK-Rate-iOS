import Foundation

struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String
    let amount: Decimal
    let countries: [String]
    let disabled: Bool

    var name: String {
        NSLocalizedString(id, tableName: "CodeDataset", comment: "")
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
        self.countries = Bundle.countryDataset.keys(forValue: id)
        self.disabled = disabled
    }
}
