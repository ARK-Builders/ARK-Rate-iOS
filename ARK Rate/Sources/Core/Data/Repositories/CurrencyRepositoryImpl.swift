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
            .map { $0.toCurrency }
            .sorted { $0.code < $1.code }
    }

    func fetchRemote() async throws -> [Currency] {
        let currencies = try await fiatCurrencyDataSource.fetch()
        try localDataSource.save(currencies)
        return currencies
            .map { $0.toCurrency }
            .sorted { $0.code < $1.code }
    }
}
