import Foundation

struct CurrencyStatisticSwiftDataDataSource: CurrencyStatisticLocalDataSource {

    // MARK: - Conformance

    func get(limit: Int) throws -> [CurrencyStatisticDTO] {
        let models: [CurrencyStatisticModel] = try SwiftDataManager.shared.get(limit: limit)
        return models.map(\.toCurrencyStatisticDTO)
    }

    func save(_ currencyStatistics: [CurrencyStatisticDTO]) throws {
        let codes = Set(currencyStatistics.map(\.code))
        let models = currencyStatistics.map(\.toCurrencyStatisticModel)
        let fetchedModels: [CurrencyStatisticModel] = try SwiftDataManager.shared.get(predicate: #Predicate { codes.contains($0.code) })
        let fetchedModelsMap = Dictionary(uniqueKeysWithValues: fetchedModels.map { ($0.code, $0) })
        for model in models {
            if let fetchedModel = fetchedModelsMap[model.code] {
                fetchedModel.usageCount += 1
                fetchedModel.lastUsedDate = model.lastUsedDate
            } else {
                try SwiftDataManager.shared.insert(model, commit: false)
            }
        }
        try SwiftDataManager.shared.save()
    }
}
