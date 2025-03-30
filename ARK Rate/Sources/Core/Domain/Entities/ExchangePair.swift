import Foundation

struct ExchangePair: Equatable {

    // MARK: - Properties

    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrenciesCode: Set<String>
}
