struct CurrencyRepositoryImpl: CurrencyRepository {

    // MARK: - Properties

    let localDataSource: CurrencyLocalDataSource
    let fiatCurrencyDataSource: CurrencyRemoteDataSource
    let cryptoCurrencyDataSource: CurrencyRemoteDataSource

    // MARK: - Conformance

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

    func getLocal(where code: String) throws -> Currency? {
        try localDataSource.get(where: code).map(\.toCurrency)
    }

    func getLocal(where codes: [String]?) throws -> [Currency] {
        try localDataSource.get(where: codes).map(\.toCurrency)
    }
}
