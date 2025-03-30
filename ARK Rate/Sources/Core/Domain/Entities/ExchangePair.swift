import Foundation

struct ExchangePair: Equatable {

    // MARK: - Properties

    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrenciesCode: [String]

    // MARK: - Initialization

    init(
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrenciesCode: [String]
    ) {
        self.inputCurrencyCode = inputCurrencyCode
        self.inputCurrencyAmount = inputCurrencyAmount
        self.outputCurrenciesCode = outputCurrenciesCode
    }
}
