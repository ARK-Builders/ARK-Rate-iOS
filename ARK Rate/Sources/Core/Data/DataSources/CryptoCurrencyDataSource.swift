struct CryptoCurrencyDataSource: CurrencyRemoteDataSource {

    // MARK: - Properties

    let apiClient: CryptoCurrenciesRateAPI

    // MARK: - Conformance

    func fetch() async throws -> [CurrencyDTO] {
        try await apiClient.fetch().map { $0.toCurrencyDTO }
    }
}
