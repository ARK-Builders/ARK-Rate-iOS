protocol CurrencyRepository {

    func get() async throws -> [Currency]
}
