struct FetchCurrenciesUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository

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
