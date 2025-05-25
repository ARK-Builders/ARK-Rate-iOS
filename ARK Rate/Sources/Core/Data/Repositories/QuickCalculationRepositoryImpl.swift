import Foundation

struct QuickCalculationRepositoryImpl: QuickCalculationRepository {

    // MARK: - Properties

    let localDataSource: QuickCalculationLocalDataSource

    // MARK: - Conformance

    func get(where id: UUID) throws -> QuickCalculation? {
        try localDataSource.get(where: id).map(\.toQuickCalculation)
    }

    func get(where groupId: UUID) throws -> [QuickCalculation] {
        try localDataSource.get(where: groupId).map(\.toQuickCalculation)
    }

    func getPinned(where groupId: UUID) throws -> [QuickCalculation] {
        try localDataSource.getPinned(where: groupId).map(\.toQuickCalculation)
    }

    func save(_ calculation: QuickCalculation) throws {
        try localDataSource.save(calculation.toQuickCalculationDTO)
    }

    func delete(where id: UUID) throws -> QuickCalculation? {
        try localDataSource.delete(where: id)?.toQuickCalculation
    }
}
