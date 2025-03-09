protocol CurrencyDataSource {

    func get() async throws -> [CurrencyDTO]
}
