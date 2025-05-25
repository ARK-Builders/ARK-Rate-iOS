import Foundation

protocol QuickCalculationGroupLocalDataSource {

    func get() throws -> [QuickCalculationGroupDTO]
    func get(where id: UUID) throws -> QuickCalculationGroupDTO?
    func get(where name: String) throws -> QuickCalculationGroupDTO?
    func save(_ group: QuickCalculationGroupDTO) throws
}
