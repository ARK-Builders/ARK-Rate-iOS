import Foundation

struct CurrencySwiftDataDataSource: CurrencyLocalDataSource {

    // MARK: - Conformance

    func get(where code: String?) throws -> CurrencyDTO? {
        let predicate: Predicate<CurrencyModel>? = {
            if let code {
                return #Predicate { $0.code == code }
            } else {
                return nil
            }
        }()
        let fetchedModel: CurrencyModel? = try SwiftDataManager.shared.get(predicate: predicate)
        return fetchedModel.map(\.toCurrencyDTO)
    }

    func get(where codes: [String]?) throws -> [CurrencyDTO] {
        let predicate: Predicate<CurrencyModel>? = {
            if let codes {
                return #Predicate { codes.contains($0.code) }
            } else {
                return nil
            }
        }()
        let fetchedModels: [CurrencyModel] = try SwiftDataManager.shared.get(predicate: predicate, limit: codes?.count)
        return fetchedModels.map(\.toCurrencyDTO)
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
