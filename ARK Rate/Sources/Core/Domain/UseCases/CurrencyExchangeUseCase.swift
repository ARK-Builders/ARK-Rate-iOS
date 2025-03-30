import Foundation

typealias CurrencyAmounts = [String: Decimal]

protocol CurrencyExchangeUseCase {

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: Decimal,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts
}

struct CurrencyExchangeUseCaseImpl: CurrencyExchangeUseCase {

    // MARK: - Conformance

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: Decimal,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts {
        var currencyAmounts: CurrencyAmounts = [:]
        outputCurrencies.forEach { outputCurrency in
            let rate = inputCurrency.rate.divideArk(outputCurrency.rate)
            currencyAmounts[outputCurrency.code] = inputCurrencyAmount * rate
        }
        return currencyAmounts
    }
}
