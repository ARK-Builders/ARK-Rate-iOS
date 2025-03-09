protocol CurrencyRepository {

    func getLocal() throws -> [Currency]
    func fetchRemote() async throws -> [Currency]
}
