import Foundation

struct ExchangePairDTO {

    // MARK: - Properties

    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrenciesCode: [String]
}
