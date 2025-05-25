import Foundation

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get(where id: UUID) throws -> QuickCalculationDTO? {
        let model: QuickCalculationModel? = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id })
        return model.map(\.toQuickCalculationDTO)
    }

    func get(where groupId: UUID) throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get(predicate: #Predicate {
            $0.group.id == groupId &&
            $0.pinnedDate == nil
        })
        return models.map(\.toQuickCalculationDTO)
    }

    func getPinned(where groupId: UUID) throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get(predicate: #Predicate {
            $0.group.id == groupId &&
            $0.pinnedDate != nil
        })
        return models.map(\.toQuickCalculationDTO)
    }

    func save(_ calculation: QuickCalculationDTO) throws {
        let groupId = calculation.group.id
        guard let group: QuickCalculationGroupModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == groupId }) else { return }
        let id = calculation.id
        let model = calculation.toQuickCalculationModel
        if let fetchedModel: QuickCalculationModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) {
            fetchedModel.pinnedDate = model.pinnedDate
            fetchedModel.calculatedDate = model.calculatedDate
            fetchedModel.inputCurrencyCode = model.inputCurrencyCode
            fetchedModel.inputCurrencyAmount = model.inputCurrencyAmount
            fetchedModel.outputCurrencyCodes = model.outputCurrencyCodes
            fetchedModel.outputCurrencyAmounts = model.outputCurrencyAmounts
            fetchedModel.group = group
            try SwiftDataManager.shared.save()
        } else {
            model.group = group
            try SwiftDataManager.shared.insert(model)
        }
    }

    func delete(where id: UUID) throws -> QuickCalculationDTO? {
        guard let model: QuickCalculationModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) else { return nil }
        try SwiftDataManager.shared.delete(model)
        return model.toQuickCalculationDTO
    }
}
