import SwiftData
import ComposableArchitecture

struct CurrencySwiftDataDataSource: CurrencyLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [CurrencyDTO] {
        let models = try SwiftDataManager.shared.get()
        return models.map { CurrencyDTO(id: $0.id, rate: $0.rate, category: CurrencyDTO.Category.fiat) }
    }

    func save(_ currencies: [CurrencyDTO]) throws {
        let models = currencies.map { CurrencyModel(id: $0.id, rate: $0.rate) }
        try SwiftDataManager.shared.insert(models)
    }
}
