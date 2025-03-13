final class CurrencyRepositoryImpl: CurrencyRepository {

    // MARK: - Properties

    private let localDataSource: CurrencyLocalDataSource
    private let fiatCurrencyDataSource: CurrencyRemoteDataSource
    private let cryptoCurrencyDataSource: CurrencyRemoteDataSource

    // MARK: - Initialization

    init(
        localDataSource: CurrencyLocalDataSource,
        fiatCurrencyDataSource: CurrencyRemoteDataSource,
        cryptoCurrencyDataSource: CurrencyRemoteDataSource
    ) {
        self.localDataSource = localDataSource
        self.fiatCurrencyDataSource = fiatCurrencyDataSource
        self.cryptoCurrencyDataSource = cryptoCurrencyDataSource
    }

    // MARK: - Conformance

    func getLocal() throws -> [Currency] {
        try localDataSource.get()
            .map { $0.toCurrency }
            .sorted { $0.code < $1.code }
    }

    func fetchRemote() async throws -> [Currency] {
        async let fiatCurrencies = fiatCurrencyDataSource.fetch()
        async let cryptoCurrencies = cryptoCurrencyDataSource.fetch()
        let currencies = try await fiatCurrencies + cryptoCurrencies
        try localDataSource.save(currencies)
        return currencies
            .map { $0.toCurrency }
            .sorted { $0.code < $1.code }
    }
}
