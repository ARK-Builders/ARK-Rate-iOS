import SwiftUI

enum QuickToastContext: Identifiable, Equatable {
    case added(QuickCalculationDisplayModel)
    case deleted(QuickCalculationDisplayModel)

    var id: UUID {
        switch self {
        case let .added(calculation), let .deleted(calculation):
            calculation.id
        }
    }

    var icon: Image {
        switch self {
        case .added: Image(.check)
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
        case let .deleted(calculation):
            TitleSubtitlePair(
                title: StringResource.deletedCalculation.localized,
                subtitle: String(format: StringResource.youDeletedCalculaion.localized, calculation.description)
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
        case deletedCalculation = "the_calculation_has_been_deleted"
        case youDeletedCalculaion = "you_deleted_calculation"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
