import Foundation

struct CurrencyDTO {

    enum Category: String {
        case fiat
        case crypto
    }

    // MARK: - Properties

    let code: String
    let rate: Decimal
    let category: Category
}
