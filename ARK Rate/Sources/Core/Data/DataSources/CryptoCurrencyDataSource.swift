final class CryptoCurrencyDataSource: CurrencyRemoteDataSource {

    // MARK: - Properties

    private let apiClient: CryptoCurrenciesRateAPI

    // MARK: - Initialziation

    init(apiClient: CryptoCurrenciesRateAPI) {
        self.apiClient = apiClient
    }

    // MARK: - Conformance

    func fetch() async throws -> [CurrencyDTO] {
        try await apiClient.fetch().map { $0.toCurrencyDTO }
    }
}
