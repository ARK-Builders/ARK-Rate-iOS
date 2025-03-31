protocol QuickCalculationLocalDataSource {

    func get() throws -> [QuickCalculationDTO]
    func save(_ pair: QuickCalculationDTO) throws
}
