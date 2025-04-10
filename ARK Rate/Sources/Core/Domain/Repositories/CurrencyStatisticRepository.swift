protocol CurrencyStatisticRepository {

    func get(limit: Int) throws -> [CurrencyStatistic]
    func save(_ currencyStatistics: [CurrencyStatistic]) throws
}
