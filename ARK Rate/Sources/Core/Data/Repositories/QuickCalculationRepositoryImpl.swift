import Foundation

struct QuickCalculationRepositoryImpl: QuickCalculationRepository {

    // MARK: - Properties

    let localDataSource: QuickCalculationLocalDataSource

    // MARK: - Conformance

    func get(where id: UUID) throws -> QuickCalculation? {
        try localDataSource.get(where: id).map(\.toQuickCalculation)
    }

    func get() throws -> [QuickCalculation] {
        try localDataSource.get().map(\.toQuickCalculation)
    }

    func getWherePinned() throws -> [QuickCalculation] {
        try localDataSource.getWherePinned().map(\.toQuickCalculation)
    }

    func save(_ calculation: QuickCalculation) throws {
        try localDataSource.save(calculation.toQuickCalculationDTO)
    }

    func delete(where id: UUID) throws -> QuickCalculation? {
        try localDataSource.delete(where: id)?.toQuickCalculation
    }
}
