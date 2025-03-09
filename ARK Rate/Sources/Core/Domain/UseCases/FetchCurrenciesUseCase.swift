struct FetchCurrenciesUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository

    // MARK: - Initialization

    init(currencyRepository: CurrencyRepository) {
        self.currencyRepository = currencyRepository
    }

    // MARK: - Methods

    func execute() -> AsyncStream<[Currency]> {
        AsyncStream { continuation in
            Task {
                let localCurrencies = try currencyRepository.getLocal()
                continuation.yield(localCurrencies)

                let remoteCurrencies = try await currencyRepository.fetchRemote()
                continuation.yield(remoteCurrencies)

                continuation.finish()
            }
        }
    }
}
