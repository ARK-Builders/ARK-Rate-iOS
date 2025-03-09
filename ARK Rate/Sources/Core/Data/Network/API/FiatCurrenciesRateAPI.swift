import Alamofire

protocol FiatCurrenciesRateAPI {

    func fetch() async throws -> FiatCurrenciesRateResponse
}

final class FiatCurrenciesRateAPIClient: FiatCurrenciesRateAPI {

    // MARK: - Constants

    private let endpoint = "https://open.er-api.com/v6/latest/USD"

    // MARK: - Conformance

    func fetch() async throws -> FiatCurrenciesRateResponse {
        try await AF.request(endpoint)
            .validate()
            .serializingDecodable(FiatCurrenciesRateResponse.self)
            .value
        // Return a fallback value when API fails
    }
}
