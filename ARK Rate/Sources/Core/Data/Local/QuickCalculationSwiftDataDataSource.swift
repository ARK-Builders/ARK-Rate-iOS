import Foundation

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get()
        return models.map(\.toQuickCalculationDTO)
    }

    func getWherePinned() throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get(predicate: #Predicate { $0.pinnedDate != nil })
        return models.map(\.toQuickCalculationDTO)
    }

    func save(_ calculation: QuickCalculationDTO) throws {
        let model = calculation.toQuickCalculationModel
        try SwiftDataManager.shared.insert(model)
    }
}
