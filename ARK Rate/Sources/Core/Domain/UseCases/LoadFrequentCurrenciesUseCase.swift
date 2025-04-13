struct LoadFrequentCurrenciesUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository
    let currencyStatisticRepository: CurrencyStatisticRepository

    // MARK: - Methods

    func execute() -> [Currency] {
        do {
            let codes = try currencyStatisticRepository
                .get()
                .sorted { $0.rating > $1.rating }
                .prefix(Constants.limit)
                .map(\.code)
            return try currencyRepository.getLocal(where: codes)
        } catch {
            return []
        }
    }
}

// MARK: - Constants

private extension LoadFrequentCurrenciesUseCase {

    enum Constants {
        static let limit = 5
    }
}
