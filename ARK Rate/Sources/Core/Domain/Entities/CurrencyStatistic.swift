import Foundation

struct CurrencyStatistic {

    // MARK: - Properties

    let code: String
    let usageCount: UInt
    let lastUsedDate: Date

    // MARK: - Initialization

    init(
        code: String,
        usageCount: UInt = 1,
        lastUsedDate: Date = Date()
    ) {
        self.code = code
        self.usageCount = usageCount
        self.lastUsedDate = lastUsedDate
    }
}
