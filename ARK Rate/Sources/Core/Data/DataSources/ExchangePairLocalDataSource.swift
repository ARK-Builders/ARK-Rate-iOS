protocol ExchangePairLocalDataSource {

    func get() throws -> [ExchangePairDTO]
    func save(_ pair: ExchangePairDTO) throws
}
