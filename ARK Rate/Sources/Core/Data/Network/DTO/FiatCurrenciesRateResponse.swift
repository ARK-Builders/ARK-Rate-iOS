struct FiatCurrenciesRateResponse: Decodable {

    // MARK: - Properties

    let rates: [String: Double]

    // MARK: - Methods

    func toDomain() -> [Currency] {
        return rates.map { Currency(id: $0.key, rate: $0.value, category: Currency.Category.fiat) }
    }
}
