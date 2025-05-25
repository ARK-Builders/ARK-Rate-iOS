import Foundation

struct SaveQuickCalculationUseCase {

    // MARK: - Properties

    let quickCalculationRepository: QuickCalculationRepository
    let quickCalculationGroupRepository: QuickCalculationGroupRepository
    let currencyStatisticRepository: CurrencyStatisticRepository

    // MARK: - Methods

    func execute(
        id: UUID?,
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrencyCodes: [String],
        outputCurrencyAmounts: [Decimal],
        groupId: UUID
    ) -> QuickCalculation? {
        guard let group = try? quickCalculationGroupRepository.get(where: groupId) else { return nil }
        let pinnedDate = id.flatMap { try? quickCalculationRepository.get(where: $0)?.pinnedDate }
        let calculationId = id ?? UUID()
        let quickCalculation = QuickCalculation(
            id: calculationId,
            pinnedDate: pinnedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group
        )
        let currencyStatistics = quickCalculation.toCurrencyStatistics
        try? quickCalculationRepository.save(quickCalculation)
        try? currencyStatisticRepository.save(currencyStatistics)
        return quickCalculation
    }
}
