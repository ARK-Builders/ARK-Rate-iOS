struct LoadQuickCalculationGroupsUseCase {

    // MARK: - Properties

    let quickCalculationGroupRepository: QuickCalculationGroupRepository

    // MARK: - Methods

    func execute() -> [QuickCalculationGroup] {
        (try? quickCalculationGroupRepository.get().sorted {
            switch ($0.displayOrder, $1.displayOrder) {
            case (nil, nil):
                return $0.addedDate > $1.addedDate
            case (nil, _):
                return false
            case (_, nil):
                return true
            default:
                return $0.displayOrder! < $1.displayOrder!
            }
        }) ?? []
    }
}
