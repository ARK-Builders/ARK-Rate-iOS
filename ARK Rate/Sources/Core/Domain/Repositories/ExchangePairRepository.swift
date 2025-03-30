protocol ExchangePairRepository {

    func save(_ pair: ExchangePair) throws
    func get() throws -> [ExchangePair]
}
