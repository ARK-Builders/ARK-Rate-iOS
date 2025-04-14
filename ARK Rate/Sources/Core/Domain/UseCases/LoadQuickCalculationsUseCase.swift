import Foundation

struct LoadQuickCalculationsUseCase {

    // MARK: - Properties

    let quickCalculationRepository: QuickCalculationRepository
    let currencyCalculationUseCase: CurrencyCalculationUseCase
    let metadataRepository: MetadataRepository

    // MARK: - Methods

    func getCalculatedCalculations() -> [QuickCalculation] {
        (try? quickCalculationRepository.get().sorted { $0.calculatedDate > $1.calculatedDate }) ?? []
    }

    func getPinnedCalculations() -> [QuickCalculation] {
        do {
            return try quickCalculationRepository.getWherePinned()
                .map { calculation in
                    var outputCurrencyAmounts = calculation.outputCurrencyAmounts
                    for (index, outputCurrencyCode) in calculation.outputCurrencyCodes.enumerated() {
                        outputCurrencyAmounts[index] = currencyCalculationUseCase.execute(
                            inputCurrencyCode: calculation.inputCurrencyCode,
                            inputCurrencyAmount: calculation.inputCurrencyAmount,
                            outputCurrencyCode: outputCurrencyCode
                        )
                    }
                    return calculation.toQuickCalculation(
                        calculatedDate: metadataRepository.lastCurrenciesFetchDate() ?? Date(),
                        outputCurrencyAmounts: outputCurrencyAmounts
                    )
                }
                .sorted { $0.pinnedDate! > $1.pinnedDate! }
        } catch {
            return []
        }
    }
}
