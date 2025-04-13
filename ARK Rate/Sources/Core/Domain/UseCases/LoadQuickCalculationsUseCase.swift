struct LoadQuickCalculationsUseCase {

    // MARK: - Properties

    let quickCalculationRepository: QuickCalculationRepository
    let currencyCalculationUseCase: CurrencyCalculationUseCase

    // MARK: - Methods

    func getCalculatedCalculations() -> [QuickCalculation] {
        (try? quickCalculationRepository.get().sorted { $0.calculatedDate > $1.calculatedDate }) ?? []
    }
}
