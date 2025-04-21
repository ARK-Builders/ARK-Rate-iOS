import Foundation

protocol QuickCalculationRepository {

    func get(where id: UUID) throws -> QuickCalculation?
    func get() throws -> [QuickCalculation]
    func getWherePinned() throws -> [QuickCalculation]
    func save(_ calculation: QuickCalculation) throws
    func delete(where id: UUID) throws -> QuickCalculation?
}
