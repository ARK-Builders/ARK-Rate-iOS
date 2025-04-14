import Foundation

struct TogglePinnedCalculationUseCase {

    // MARK: - Properties

    let quickCalculationRepository: QuickCalculationRepository

    // MARK: - Methods

    func execute(_ id: UUID) {
        guard let calculation = try? quickCalculationRepository.get(where: id) else { return }
        let pinnedDate: Date? = calculation.pinnedDate == nil ? Date() : nil
        let updated = calculation.toQuickCalculation(pinnedDate: pinnedDate)
        try? quickCalculationRepository.save(updated)
    }
}
