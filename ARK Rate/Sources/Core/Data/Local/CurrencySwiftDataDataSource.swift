import Foundation

struct CurrencySwiftDataDataSource: CurrencyLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [CurrencyDTO] {
        let models: [CurrencyModel] = try SwiftDataManager.shared.get()
        return models.map(\.toCurrencyDTO)
    }

    func save(_ currencies: [CurrencyDTO]) throws {
        let codes = Set(currencies.map(\.code))
        let models = currencies.map(\.toCurrencyModel)
        let fetchedModels: [CurrencyModel] = try SwiftDataManager.shared.get(predicate: #Predicate { codes.contains($0.code) })
        let fetchedModelsMap = Dictionary(uniqueKeysWithValues: fetchedModels.map { ($0.code, $0) })
        for model in models {
            if let fetchedModel = fetchedModelsMap[model.code] {
                fetchedModel.rate = model.rate
            } else {
                try SwiftDataManager.shared.insert(model, commit: false)
            }
        }
        try SwiftDataManager.shared.save()
    }
}
