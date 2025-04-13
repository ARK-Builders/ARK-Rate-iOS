import Foundation

struct Currency {

    enum Category {
        case fiat
        case crypto
    }

    // MARK: - Properties

    let code: String
    let rate: Decimal
    let category: Category
}
