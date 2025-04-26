import SwiftUI

enum QuickToastContext: Identifiable, Equatable {
    case added(QuickCalculationDisplayModel)
    case edited(QuickCalculationDisplayModel)
    case reused(QuickCalculationDisplayModel)
    case deleted(QuickCalculationDisplayModel)

    var id: UUID {
        switch self {
        case let .added(calculation),
            let .edited(calculation),
            let .reused(calculation),
            let .deleted(calculation):
            calculation.id
        }
    }

    var icon: Image {
        switch self {
        case .added, .edited, .reused: Image(.check)
        case .deleted: Image(.info)
        }
    }

    var content: TitleSubtitlePair {
        switch self {
        case let .added(calculation):
            TitleSubtitlePair(
                title: StringResource.addedCalculation.localized,
                subtitle: String(format: StringResource.youAddedCalculation.localized, calculation.description)
            )
        case let .edited(calculation):
            TitleSubtitlePair(
                title: StringResource.editedCalculation.localized,
                subtitle: String(format: StringResource.youEditedCalculation.localized, calculation.description)
            )
        case let .reused(calculation):
            TitleSubtitlePair(
                title: StringResource.reusedCalculation.localized,
                subtitle: String(format: StringResource.youReusedCalculation.localized, calculation.description)
            )
        case let .deleted(calculation):
            TitleSubtitlePair(
                title: StringResource.deletedCalculation.localized,
                subtitle: String(format: StringResource.youDeletedCalculation.localized, calculation.description)
            )
        }
    }

    var actionButtonTitle: String? {
        switch self {
        case .deleted: StringResource.undo.localized
        default: nil
        }
    }
}

// MARK: - Constants

private extension QuickToastContext {

    enum StringResource: String.LocalizationValue {
        case undo
        case addedCalculation = "new_calculation_has_been_created"
        case youAddedCalculation = "you_added_calculation"
        case editedCalculation = "calculation_has_been_edited"
        case youEditedCalculation = "you_edited_calculation"
        case reusedCalculation = "calculation_has_been_reused"
        case youReusedCalculation = "you_reused_calculation"
        case deletedCalculation = "the_calculation_has_been_deleted"
        case youDeletedCalculation = "you_deleted_calculation"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
