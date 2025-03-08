protocol FiatCurrencyRepository {

    func get() async throws -> [FiatCurrency]
}
