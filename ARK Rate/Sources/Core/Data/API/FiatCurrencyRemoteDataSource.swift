import Alamofire

final class FiatCurrencyRemoteDataSource {

    // MARK: - Constants

    private let endpoint = "https://open.er-api.com/v6/latest/USD"
}

extension FiatCurrencyRemoteDataSource: FiatCurrencyService {

    func fetchRates() async throws -> FiatCurrencyDTO {
        try await AF.request(endpoint)
            .validate()
            .serializingDecodable(FiatCurrencyDTO.self)
            .value
        // Return a fallback value when API fails
    }
}
