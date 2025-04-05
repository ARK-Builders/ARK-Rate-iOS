import Foundation

struct QuickCalculation: Equatable {

    // MARK: - Properties

    let id: UUID
    let calculatedDate: Date
    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrenciesCode: [String]

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        calculatedDate: Date = Date(),
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrenciesCode: [String]
    ) {
        self.id = id
        self.calculatedDate = calculatedDate
        self.inputCurrencyCode = inputCurrencyCode
        self.inputCurrencyAmount = inputCurrencyAmount
        self.outputCurrenciesCode = outputCurrenciesCode
    }

    // MARK: - Conformance

    static func == (lhs: QuickCalculation, rhs: QuickCalculation) -> Bool {
        return lhs.id == rhs.id
    }
}
