struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String
    let formattedRate: String

    var name: String {
        String(localized: String.LocalizationValue(id))
    }

    // MARK: - Initialization

    init(from fiatCurrency: Currency) {
        self.id = fiatCurrency.code
        self.formattedRate = fiatCurrency.rate.formattedRate
    }
}
