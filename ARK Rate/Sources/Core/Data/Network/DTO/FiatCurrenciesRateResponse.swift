import Foundation

struct FiatCurrenciesRateResponse: Decodable {

    // MARK: - Properties

    let timestamp: TimeInterval
    let rates: [String: Decimal]
}
