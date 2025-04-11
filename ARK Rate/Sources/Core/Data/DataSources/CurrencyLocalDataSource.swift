protocol CurrencyLocalDataSource {

    func get(where codes: [String]?) throws -> [CurrencyDTO]
    func save(_ currencies: [CurrencyDTO]) throws
}

extension CurrencyLocalDataSource {

    func get() throws -> [CurrencyDTO] {
        try get(where: nil)
    }
}
