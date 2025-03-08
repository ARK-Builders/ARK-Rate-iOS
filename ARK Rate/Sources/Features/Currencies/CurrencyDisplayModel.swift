struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String
    let formattedRate: String

    // MARK: - Initialization

    init(from fiatCurrency: FiatCurrency) {
        self.id = fiatCurrency.id
        self.formattedRate = String(format: "%.2f", fiatCurrency.rate)
    }
}
