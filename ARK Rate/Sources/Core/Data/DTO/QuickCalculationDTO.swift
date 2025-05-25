import Foundation

struct QuickCalculationDTO {

    // MARK: - Properties

    let id: UUID
    let pinnedDate: Date?
    let calculatedDate: Date
    let inputCurrencyCode: String
    let inputCurrencyAmount: Decimal
    let outputCurrencyCodes: [String]
    let outputCurrencyAmounts: [Decimal]
    let group: QuickCalculationGroupDTO
}
