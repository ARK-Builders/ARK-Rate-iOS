struct FiatCurrencyDataSource: CurrencyRemoteDataSource {

    // MARK: - Properties

    let apiClient: FiatCurrenciesRateAPI

    // MARK: - Conformance

    func fetch() async throws -> [CurrencyDTO] {
        try await apiClient.fetch().toCurrencyDTOs
    }
}
