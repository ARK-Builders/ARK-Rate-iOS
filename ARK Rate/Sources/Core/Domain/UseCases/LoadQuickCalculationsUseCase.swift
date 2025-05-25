import Foundation

struct LoadQuickCalculationsUseCase {

    // MARK: - Properties

    let metadataRepository: MetadataRepository
    let quickCalculationRepository: QuickCalculationRepository
    let currencyCalculationUseCase: CurrencyCalculationUseCase

    // MARK: - Methods

    func getCalculatedCalculations(groupBy groups: [QuickCalculationGroup]) -> [[QuickCalculation]] {
        groups
            .map { group in
                (try? quickCalculationRepository
                    .get(where: group.id)
                    .sorted { $0.calculatedDate > $1.calculatedDate }
                ) ?? []
            }
    }

    func getPinnedCalculations(groupBy groups: [QuickCalculationGroup]) -> [[QuickCalculation]] {
        groups
            .map { group in
                (try? quickCalculationRepository.getPinned(where: group.id)
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
                ) ?? []
            }
    }
}
