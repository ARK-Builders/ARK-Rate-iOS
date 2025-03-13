import Foundation

struct CryptoCurrencyRateResponse: Decodable {

    // MARK: - Properties

    var symbol: String
    var currentPrice: Decimal

    enum CodingKeys: String, CodingKey {
        case symbol
        case currentPrice = "current_price"
    }
}
