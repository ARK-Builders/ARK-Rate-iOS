import Alamofire

protocol FiatCurrenciesRateAPI {

    func fetch() async throws -> FiatCurrenciesRateResponse
}

// MARK: -

struct FiatCurrenciesRateAPIClient: FiatCurrenciesRateAPI {

    // MARK: - Constants

    private let endpoint = AppConfig.fiatRateUrl

    // MARK: - Conformance

    func fetch() async throws -> FiatCurrenciesRateResponse {
        try await AF.request(endpoint)
            .validate()
            .serializingDecodable(FiatCurrenciesRateResponse.self)
            .value
        // Return a fallback value when API fails
    }
}
