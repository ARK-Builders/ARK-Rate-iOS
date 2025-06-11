import Alamofire

protocol CryptoCurrenciesRateAPI {

    func fetch() async throws -> [CryptoCurrencyRateResponse]
}

// MARK: -

struct CryptoCurrenciesRateAPIClient: CryptoCurrenciesRateAPI {

    // MARK: - Constants

    private let endpoint = AppConfig.cryptoRatesUrl

    // MARK: - Conformance

    func fetch() async throws -> [CryptoCurrencyRateResponse] {
        try await AF.request(endpoint)
            .validate()
            .serializingDecodable([CryptoCurrencyRateResponse].self)
            .value
        // Return a fallback value when API fails
    }
}
