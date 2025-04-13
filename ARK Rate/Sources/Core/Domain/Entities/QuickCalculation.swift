import Foundation

struct QuickCalculation {

    // MARK: - Properties

    let id: UUID
    let pinnedDate: Date?
    let calculatedDate: Date
    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrencyCodes: [String]
    let outputCurrencyAmounts: [Decimal]

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        pinnedDate: Date? = nil,
        calculatedDate: Date = Date(),
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
