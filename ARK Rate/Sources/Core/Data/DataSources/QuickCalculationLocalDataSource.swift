import Foundation

protocol QuickCalculationLocalDataSource {

    func get(where id: UUID) throws -> QuickCalculationDTO?
    func get() throws -> [QuickCalculationDTO]
    func getWherePinned() throws -> [QuickCalculationDTO]
    func save(_ calculation: QuickCalculationDTO) throws
    func delete(where id: UUID) throws -> QuickCalculationDTO?
}
