protocol CurrencyStatisticLocalDataSource {

    func get() throws -> [CurrencyStatisticDTO]
    func save(_ currencyStatistics: [CurrencyStatisticDTO]) throws
}
