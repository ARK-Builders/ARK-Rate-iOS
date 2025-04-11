struct LoadCurrenciesUseCase {

    // MARK: - Properties

    let currencyRepository: CurrencyRepository

    // MARK: - Methods

    func fetchRemote() -> AsyncStream<[Currency]> {
        AsyncStream { continuation in
            Task {
                let localCurrencies = try currencyRepository.getLocal()
                    .sorted { $0.code < $1.code }
                continuation.yield(localCurrencies)

                let remoteCurrencies = try await currencyRepository.fetchRemote()
                    .sorted { $0.code < $1.code }
                continuation.yield(remoteCurrencies)

                continuation.finish()
            }
        }
    }

    func getLocal() -> [Currency] {
        (try? currencyRepository.getLocal().sorted { $0.code < $1.code }) ?? []
    }
}
