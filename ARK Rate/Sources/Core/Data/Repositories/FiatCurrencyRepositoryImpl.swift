final class FiatCurrencyRepositoryImpl {

    // MARK: - Properties

    private let service: FiatCurrencyService

    // MARK: - Initialization

    init(service: FiatCurrencyService) {
        self.service = service
    }
}

extension FiatCurrencyRepositoryImpl: FiatCurrencyRepository {

    func get() async throws -> [FiatCurrency] {
        try await service.fetchRates().toDomain()
        // Handle fallback value
    }
}
