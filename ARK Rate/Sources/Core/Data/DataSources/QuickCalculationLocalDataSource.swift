import Foundation

protocol QuickCalculationLocalDataSource {

    func get(where id: UUID) throws -> QuickCalculationDTO?
    func get(where groupId: UUID) throws -> [QuickCalculationDTO]
    func getPinned(where groupId: UUID) throws -> [QuickCalculationDTO]
    func save(_ calculation: QuickCalculationDTO) throws
    func delete(where id: UUID) throws -> QuickCalculationDTO?
}
