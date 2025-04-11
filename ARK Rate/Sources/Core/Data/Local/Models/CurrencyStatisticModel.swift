import Foundation
import SwiftData

@Model
final class CurrencyStatisticModel {

    // MARK: - Properties

    @Attribute(.unique) var code: String
    var usageCount: UInt
    var lastUsedDate: Date

    // MARK: - Initialization

    init(code: String, usageCount: UInt, lastUsedDate: Date) {
        self.code = code
        self.usageCount = usageCount
        self.lastUsedDate = lastUsedDate
    }
}
