protocol CurrencyRepository {

    func getLocal(where codes: [String]?) throws -> [Currency]
    func fetchRemote() async throws -> [Currency]
}

extension CurrencyRepository {

    func getLocal() throws -> [Currency] {
        try getLocal(where: nil)
    }
}
