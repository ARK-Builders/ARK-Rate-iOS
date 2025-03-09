final class CurrencyRepositoryImpl: CurrencyRepository {

    // MARK: - Properties

    private let fiatCurrencyDataSource: FiatCurrencyDataSource

    // MARK: - Initialization

    init(fiatCurrencyDataSource: FiatCurrencyDataSource) {
        self.fiatCurrencyDataSource = fiatCurrencyDataSource
    }

    // MARK: - Conformance

    func get() async throws -> [Currency] {
        try await fiatCurrencyDataSource.get().map { Currency(id: $0.id, rate: $0.rate, category: Currency.Category.fiat) }
    }
}
