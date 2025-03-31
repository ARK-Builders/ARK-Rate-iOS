import SwiftData

struct QuickCalculationSwiftDataDataSource: QuickCalculationLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [QuickCalculationDTO] {
        let models = try SwiftDataManager.shared.get(QuickCalculationModel.self)
        return models.map { $0.toQuickCalculationDTO }
    }

    func save(_ pair: QuickCalculationDTO) throws {
        let model = pair.toQuickCalculationModel
        try SwiftDataManager.shared.insertOrUpdate(model)
    }
}
