import Foundation

typealias CurrencyAmounts = [String: String]

protocol CurrencyCalculationUseCase {

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: Decimal,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts
}

struct CurrencyCalculationUseCaseImpl: CurrencyCalculationUseCase {

    // MARK: - Conformance

    func execute(
        inputCurrency: Currency,
        inputCurrencyAmount: Decimal,
        outputCurrencies: [Currency]
    ) -> CurrencyAmounts {
        var currencyAmounts: CurrencyAmounts = [:]
        outputCurrencies.forEach { outputCurrency in
            let rate = inputCurrency.rate.divideArk(outputCurrency.rate)
            currencyAmounts[outputCurrency.code] = (inputCurrencyAmount * rate).formattedRate
        }
        return currencyAmounts
    }
}
