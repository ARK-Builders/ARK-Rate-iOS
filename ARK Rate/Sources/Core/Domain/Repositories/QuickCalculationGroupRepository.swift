import Foundation

protocol QuickCalculationGroupRepository {

    func get() throws -> [QuickCalculationGroup]
    func get(where id: UUID) throws -> QuickCalculationGroup?
    func get(where name: String) throws -> QuickCalculationGroup?
    func save(_ group: QuickCalculationGroup) throws
    func delete(where id: UUID) throws
}
