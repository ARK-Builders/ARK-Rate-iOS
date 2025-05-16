import Foundation

protocol QuickCalculationGroupRepository {

    func get() throws -> [QuickCalculationGroup]
    func get(where id: UUID) throws -> QuickCalculationGroup?
    func save(_ group: QuickCalculationGroup) throws
}
