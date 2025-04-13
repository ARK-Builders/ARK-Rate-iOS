protocol QuickCalculationLocalDataSource {

    func get() throws -> [QuickCalculationDTO]
    func getWherePinned() throws -> [QuickCalculationDTO]
    func save(_ calculation: QuickCalculationDTO) throws
}
