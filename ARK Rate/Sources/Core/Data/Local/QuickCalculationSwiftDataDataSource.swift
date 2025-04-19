import Foundation

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get(where id: UUID) throws -> QuickCalculationDTO? {
        let model: QuickCalculationModel? = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id })
        return model.map(\.toQuickCalculationDTO)
    }

    func get() throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get(predicate: #Predicate { $0.pinnedDate == nil })
        return models.map(\.toQuickCalculationDTO)
    }

    func getWherePinned() throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get(predicate: #Predicate { $0.pinnedDate != nil })
        return models.map(\.toQuickCalculationDTO)
    }

    func save(_ calculation: QuickCalculationDTO) throws {
        let id = calculation.id
        let model = calculation.toQuickCalculationModel
        if let fetchedModel: QuickCalculationModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) {
            fetchedModel.pinnedDate = model.pinnedDate
            fetchedModel.calculatedDate = model.calculatedDate
            fetchedModel.inputCurrencyCode = model.inputCurrencyCode
            fetchedModel.inputCurrencyAmount = model.inputCurrencyAmount
            fetchedModel.outputCurrencyCodes = model.outputCurrencyCodes
            fetchedModel.outputCurrencyAmounts = model.outputCurrencyAmounts
            try SwiftDataManager.shared.save()
        } else {
            try SwiftDataManager.shared.insert(model)
        }
    }

    func delete(where id: UUID) throws {
        guard let model: QuickCalculationModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) else { return }
        try SwiftDataManager.shared.delete(model)
    }
}
