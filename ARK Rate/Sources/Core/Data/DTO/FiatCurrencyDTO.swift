struct FiatCurrencyDTO: Decodable {

    // MARK: - Properties

    let rates: [String: Double]

    // MARK: - Methods

    func toDomain() -> [FiatCurrency] {
        return rates.map { FiatCurrency(id: $0.key, rate: $0.value) }
    }
}
