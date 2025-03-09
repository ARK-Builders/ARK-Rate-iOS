protocol CurrencyLocalDataSource {

    func get() throws -> [CurrencyDTO]
    func save(_ currencies: [CurrencyDTO]) throws
}
