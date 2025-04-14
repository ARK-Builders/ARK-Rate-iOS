struct CurrencyStatisticRepositoryImpl: CurrencyStatisticRepository {

    // MARK: - Properties

    let localDataSource: CurrencyStatisticLocalDataSource

    // MARK: - Conformance

    func get() throws -> [CurrencyStatistic] {
        try localDataSource.get().map(\.toCurrencyStatistic)
    }

    func save(_ currencyStatistics: [CurrencyStatistic]) throws {
        try localDataSource.save(currencyStatistics.map(\.toCurrencyStatisticDTO))
    }
}
