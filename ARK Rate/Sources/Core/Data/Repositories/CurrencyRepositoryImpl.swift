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

    func getLocal(where codes: [String]?) throws -> [Currency] {
        try localDataSource.get(where: codes).map(\.toCurrency)
    }

    func fetchRemote() async throws -> [Currency] {
        async let fiatTask = fiatCurrencyDataSource.fetch()
        async let cryptoTask = cryptoCurrencyDataSource.fetch()
        let (fiatCurrencies, cryptoCurrencies) = try await (fiatTask, cryptoTask)
        let fiatCodes = Set(fiatCurrencies.map(\.code))
        let cryptoCodes = Set(cryptoCurrencies.map(\.code))
        let fiatDuplicateCodes = fiatCodes.intersection(cryptoCodes)
        let fiatFilteredCurrencies = fiatCurrencies.filter { !fiatDuplicateCodes.contains($0.code) }
        let currencies = fiatFilteredCurrencies + cryptoCurrencies
        try localDataSource.save(currencies)
        return currencies.map(\.toCurrency)
    }
}
