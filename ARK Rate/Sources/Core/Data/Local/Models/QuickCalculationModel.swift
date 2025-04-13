import Foundation
import SwiftData

@Model
final class QuickCalculationModel {

    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var pinnedDate: Date?
    var calculatedDate: Date
    var inputCurrencyCode: String
    var inputCurrencyAmount: Decimal
    var outputCurrencyCodes: [String]
    var outputCurrencyAmounts: [Decimal]

    // MARK: - Initialization

    init(
        id: UUID,
        pinnedDate: Date?,
        calculatedDate: Date,
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrencyCodes: [String],
        outputCurrencyAmounts: [Decimal]
    ) {
        self.id = id
        self.pinnedDate = pinnedDate
        self.calculatedDate = calculatedDate
        self.inputCurrencyCode = inputCurrencyCode
        self.inputCurrencyAmount = inputCurrencyAmount
        self.outputCurrencyCodes = outputCurrencyCodes
        self.outputCurrencyAmounts = outputCurrencyAmounts
    }
}
