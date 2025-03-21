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

        var hasChanges = false
        models.forEach { model in
            if let fetchedModel = fetchedModelsMap[model.code] {
                if fetchedModel.rate != model.rate {
                    fetchedModel.rate = model.rate
                    hasChanges = true
                }
            } else {
                modelContext.insert(model)
                hasChanges = true
            }
        }

        if hasChanges {
            try modelContext.save()
        }
    }

    func get() throws -> [CurrencyModel] {
        guard let modelContext else { return [] }
        let fetchDescriptor = FetchDescriptor<CurrencyModel>()
        return try modelContext.fetch(fetchDescriptor)
    }
}
