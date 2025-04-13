protocol CurrencyRepository {

    func fetchRemote() async throws -> [Currency]
    func getLocal(where code: String?) throws -> Currency?
    func getLocal(where codes: [String]?) throws -> [Currency]
}

extension CurrencyRepository {

    func getLocal() throws -> Currency? {
        try getLocal(where: nil)
    }

    func getLocal() throws -> [Currency] {
        try getLocal(where: nil)
    }
}
