import Foundation

typealias CurrencyAmounts = [String: Decimal]

protocol CurrencyExchangeUseCase {

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: String,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts
}

struct CurrencyExchangeUseCaseImpl: CurrencyExchangeUseCase {

    // MARK: - Conformance

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: String,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts {
        var currencyAmounts: CurrencyAmounts = [:]
        guard let amount = Decimal(string: inputCurrencyAmount) else { return currencyAmounts }
        outputCurrencies.forEach { outputCurrency in
            let rate = inputCurrency.rate.divideArk(outputCurrency.rate)
            currencyAmounts[outputCurrency.code] = amount * rate
        }
        return currencyAmounts
    }
}
