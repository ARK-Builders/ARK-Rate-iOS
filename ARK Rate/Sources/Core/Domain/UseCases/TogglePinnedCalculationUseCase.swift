import Foundation

struct TogglePinnedCalculationUseCase {

    // MARK: - Properties

    let quickCalculationRepository: QuickCalculationRepository

    // MARK: - Methods

    func execute(_ id: UUID) -> QuickCalculation? {
        guard let calculation = try? quickCalculationRepository.get(where: id) else { return nil }
        let pinnedDate: Date? = calculation.pinnedDate == nil ? Date() : nil
        let updated = calculation.toQuickCalculation(pinnedDate: pinnedDate)
        try? quickCalculationRepository.save(updated)
        return updated
    }
}
