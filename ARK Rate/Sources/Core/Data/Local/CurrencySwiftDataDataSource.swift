import SwiftData
import ComposableArchitecture

struct CurrencySwiftDataDataSource: CurrencyLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [CurrencyDTO] {
        let models = try SwiftDataManager.shared.get()
        return models.map { $0.toCurrencyDTO }
    }

    func save(_ currencies: [CurrencyDTO]) throws {
        let models = currencies.map { $0.toCurrencyModel }
        try SwiftDataManager.shared.insertOrUpdate(models)
    }
}
