import Foundation
import SwiftData

@Model
final class CurrencyModel {
    @Attribute(.unique) var code: String
    var rate: Decimal
    var categoryRaw: String

    init(code: String, rate: Decimal, categoryRaw: String) {
        self.code = code
        self.rate = rate
        self.categoryRaw = categoryRaw
    }
}
