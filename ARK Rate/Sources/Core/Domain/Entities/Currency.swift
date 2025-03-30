import Foundation

struct Currency: Equatable {

    enum Category {
        case fiat
        case crypto
    }

    // MARK: - Properties

    let code: String
    let rate: Decimal
    let category: Category
}
