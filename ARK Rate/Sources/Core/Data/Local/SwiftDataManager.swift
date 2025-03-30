import Foundation
import SwiftData

final class SwiftDataManager {

    // MARK: - Properties

    static let shared = SwiftDataManager()

    var modelContext: ModelContext?

    // MARK: - Methods

    func insertOrUpdate(_ models: [CurrencyModel]) throws {
        guard let modelContext else { return }

        let ids = Set(models.map { $0.code })
        let fetchDescriptor = FetchDescriptor<CurrencyModel>(predicate: #Predicate { ids.contains($0.code) })
        let fetchedModels = try modelContext.fetch(fetchDescriptor)
        let fetchedModelsMap = Dictionary(uniqueKeysWithValues: fetchedModels.map { ($0.code, $0) })

        models.forEach { model in
            if let fetchedModel = fetchedModelsMap[model.code] {
                fetchedModel.rate = model.rate
            } else {
                modelContext.insert(model)
            }
        }
        try modelContext.save()
    }

    func insertOrUpdate(_ model: ExchangePairModel) throws {
        guard let modelContext else { return }

        modelContext.insert(model)
        try modelContext.save()
    }

    func get<T: PersistentModel>(_ type: T.Type) throws -> [T] {
        guard let modelContext else { return [] }
        let fetchDescriptor = FetchDescriptor<T>()
        return try modelContext.fetch(fetchDescriptor)
    }
}
