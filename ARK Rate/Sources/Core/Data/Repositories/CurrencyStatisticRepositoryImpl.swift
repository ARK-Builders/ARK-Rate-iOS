final class CurrencyStatisticRepositoryImpl: CurrencyStatisticRepository {

    // MARK: - Properties

    private let localDataSource: CurrencyStatisticLocalDataSource

    // MARK: - Initialization

    init(localDataSource: CurrencyStatisticLocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Conformance

    func get(limit: Int) throws -> [CurrencyStatistic] {
        try localDataSource.get(limit: limit)
            .map(\.toCurrencyStatistic)
    }

    func save(_ currencyStatistics: [CurrencyStatistic]) throws {
        try localDataSource.save(
            currencyStatistics.map(\.toCurrencyStatisticDTO)
        )
    }
}
