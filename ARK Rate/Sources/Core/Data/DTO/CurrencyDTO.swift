struct CurrencyDTO {

    enum Category {
        case fiat
        case crypto
    }

    // MARK: - Properties

    let id: String
    let rate: Double
    let category: Category
}
