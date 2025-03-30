import Foundation
import SwiftData

@Model
final class CurrencyModel {

    // MARK: - Properties

    @Attribute(.unique) var code: String
    var rate: Decimal
    var categoryRaw: String

    // MARK: - Initialization

    init(code: String, rate: Decimal, categoryRaw: String) {
        self.code = code
        self.rate = rate
        self.categoryRaw = categoryRaw
    }
}
