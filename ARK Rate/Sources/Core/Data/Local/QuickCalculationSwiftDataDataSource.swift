import SwiftData

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [QuickCalculationDTO] {
        let models: [QuickCalculationModel] = try SwiftDataManager.shared.get()
        return models.map(\.toQuickCalculationDTO)
    }

    func save(_ calculation: QuickCalculationDTO) throws {
        let model = calculation.toQuickCalculationModel
        try SwiftDataManager.shared.insert(model)
    }
}
