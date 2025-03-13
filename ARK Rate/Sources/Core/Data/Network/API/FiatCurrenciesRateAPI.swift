import Alamofire

protocol FiatCurrenciesRateAPI {

    func fetch() async throws -> FiatCurrenciesRateResponse
}

// MARK: -

final class FiatCurrenciesRateAPIClient: FiatCurrenciesRateAPI {

    // MARK: - Constants

    private let endpoint = "https://raw.githubusercontent.com/ARK-Builders/ark-exchange-rates/main/fiat-rates.json"

    // MARK: - Conformance

    func fetch() async throws -> FiatCurrenciesRateResponse {
        try await AF.request(endpoint)
            .validate()
            .serializingDecodable(FiatCurrenciesRateResponse.self)
            .value
        // Return a fallback value when API fails
    }
}
