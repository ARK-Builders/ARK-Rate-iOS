struct CurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id: String

    var name: String {
        String(localized: String.LocalizationValue(id))
    }

    // MARK: - Initialization

    init(from currency: Currency) {
        self.id = currency.code
    }
}
