struct FetchCurrenciesUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository

    // MARK: - Initialization

    init(currencyRepository: CurrencyRepository) {
        self.currencyRepository = currencyRepository
    }

    // MARK: - Methods

    func execute() async throws -> [Currency] {
        try await currencyRepository.get()
    }
}
