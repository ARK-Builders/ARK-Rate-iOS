import Alamofire

final class FiatCurrencyDataSource: CurrencyRemoteDataSource {

    // MARK: - Properties

    private let apiClient: FiatCurrenciesRateAPI

    // MARK: - Initialziation

    init(apiClient: FiatCurrenciesRateAPI) {
        self.apiClient = apiClient
    }

    // MARK: - Conformance

    func fetch() async throws -> [CurrencyDTO] {
        try await apiClient.fetch().toCurrencyDTOs
    }
}
