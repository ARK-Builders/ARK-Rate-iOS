protocol CurrencyStatisticRepository {

    func get() throws -> [CurrencyStatistic]
    func save(_ currencyStatistics: [CurrencyStatistic]) throws
}
