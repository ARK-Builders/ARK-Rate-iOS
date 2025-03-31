import SwiftData

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [QuickCalculationDTO] {
        let models = try SwiftDataManager.shared.get(QuickCalculationModel.self)
        return models.map { $0.toQuickCalculationDTO }
    }

    func save(_ calculation: QuickCalculationDTO) throws {
        let model = calculation.toQuickCalculationModel
        try SwiftDataManager.shared.insertOrUpdate(model)
    }
}
