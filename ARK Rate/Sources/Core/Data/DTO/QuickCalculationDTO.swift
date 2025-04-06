import Foundation

struct QuickCalculationDTO {

    // MARK: - Properties

    let id: UUID
    let calculatedDate: Date
    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrenciesCode: [String]
}
