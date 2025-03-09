final class CurrencyRepositoryImpl: CurrencyRepository {

    // MARK: - Properties

    private let localDataSource: CurrencyLocalDataSource
    private let fiatCurrencyDataSource: CurrencyRemoteDataSource

    // MARK: - Initialization

    init(localDataSource: CurrencyLocalDataSource, fiatCurrencyDataSource: CurrencyRemoteDataSource) {
        self.localDataSource = localDataSource
        self.fiatCurrencyDataSource = fiatCurrencyDataSource
    }

    // MARK: - Conformance

    func getLocal() throws -> [Currency] {
        try localDataSource.get()
            .map { Currency(id: $0.id, rate: $0.rate, category: Currency.Category.fiat) }
            .sorted { $0.id < $1.id }
    }

    func fetchRemote() async throws -> [Currency] {
        let currencies = try await fiatCurrencyDataSource.fetch()
        try localDataSource.save(currencies)
        return currencies
            .map { Currency(id: $0.id, rate: $0.rate, category: Currency.Category.fiat) }
            .sorted { $0.id < $1.id }
    }
}
