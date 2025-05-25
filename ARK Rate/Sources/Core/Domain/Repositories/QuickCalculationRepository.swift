import Foundation

protocol QuickCalculationRepository {

    func get(where id: UUID) throws -> QuickCalculation?
    func get(where groupId: UUID) throws -> [QuickCalculation]
    func getPinned(where groupId: UUID) throws -> [QuickCalculation]
    func save(_ calculation: QuickCalculation) throws
    func delete(where id: UUID) throws -> QuickCalculation?
}
