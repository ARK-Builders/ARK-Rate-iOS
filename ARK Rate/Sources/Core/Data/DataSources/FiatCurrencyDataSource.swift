import Alamofire

final class FiatCurrencyDataSource: CurrencyDataSource {

    // MARK: - Properties

    private let apiClient: FiatCurrenciesRateAPI

    // MARK: - Initialziation

    init(apiClient: FiatCurrenciesRateAPI) {
        self.apiClient = apiClient
    }

    // MARK: - Conformance

    func get() async throws -> [CurrencyDTO] {
        try await apiClient.fetch().rates.map {
            CurrencyDTO(id: $0.key, rate: $0.value, category: CurrencyDTO.Category.fiat)
        }
    }
}
