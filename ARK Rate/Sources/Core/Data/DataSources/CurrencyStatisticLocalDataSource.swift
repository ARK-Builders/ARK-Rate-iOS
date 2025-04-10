protocol CurrencyStatisticLocalDataSource {

    func get(limit: Int) throws -> [CurrencyStatisticDTO]
    func save(_ currencyStatistics: [CurrencyStatisticDTO]) throws
}
