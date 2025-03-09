import SwiftData

@Model
final class CurrencyModel {
    @Attribute(.unique) var id: String
    var rate: Double

    init(id: String, rate: Double) {
        self.id = id
        self.rate = rate
    }
}
