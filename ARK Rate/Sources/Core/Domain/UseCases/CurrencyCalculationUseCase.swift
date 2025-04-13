import Foundation

struct CurrencyCalculationUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository

    // MARK: - Methods

    func execute(
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrencyCode: String
    ) -> Decimal {
        guard let inputCurrency = try? currencyRepository.getLocal(where: inputCurrencyCode),
              let outputCurrency = try? currencyRepository.getLocal(where: outputCurrencyCode) else {
            return 0
        }
        let rate = inputCurrency.rate.divideArk(outputCurrency.rate)
        return inputCurrencyAmount * rate
    }
}
