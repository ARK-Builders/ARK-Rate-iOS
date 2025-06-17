import Foundation

struct QuickCalculationGroupRepositoryImpl: QuickCalculationGroupRepository {

    // MARK: - Properties

    let localDataSource: QuickCalculationGroupLocalDataSource

    // MARK: - Conformance

    func get() throws -> [QuickCalculationGroup] {
        try localDataSource.get().map(\.toQuickCalculationGroup)
    }

    func get(where id: UUID) throws -> QuickCalculationGroup? {
        try localDataSource.get(where: id).map(\.toQuickCalculationGroup)
    }

    func get(where name: String) throws -> QuickCalculationGroup? {
        try localDataSource.get(where: name).map(\.toQuickCalculationGroup)
    }

    func save(_ group: QuickCalculationGroup) throws {
        try localDataSource.save(group.toQuickCalculationGroupDTO)
    }

    func delete(where id: UUID) throws {
        try localDataSource.delete(where: id)
    }
}
