import Foundation

struct CurrencyStatistic {

    // MARK: - Properties

    let code: String
    let usageCount: UInt
    let lastUsedDate: Date

    var rating: Double {
        let daysPassedSinceNow = lastUsedDate.daysPassedSinceNow
        let timeFactor = Double(daysPassedSinceNow) * 0.5
        return Double(usageCount) - timeFactor
    }

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
