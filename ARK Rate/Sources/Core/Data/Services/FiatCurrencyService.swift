protocol FiatCurrencyService {

    func fetchRates() async throws -> FiatCurrencyDTO
}
