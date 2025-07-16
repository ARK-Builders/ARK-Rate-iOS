import Foundation

extension Date {

    // MARK: - Properties

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    var hasElapsedOneWeek: Bool {
        let components = Calendar.current.dateComponents([.day], from: self, to: Date())
        return (components.day ?? 0) >= 7
    }

    var formattedElapsedTime: String {
        if hasElapsedOneWeek {
            return Date.formatter.string(from: self)
        }
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        switch (
            components.day ?? 0,
            components.hour ?? 0,
            components.minute ?? 0,
            components.second ?? 0
        ) {
        case let (day, _, _, _) where day > 0:
            return StringResource.day.localizedFormat(day)
        case let (_, hour, _, _) where hour > 0:
            return StringResource.hour.localizedFormat(hour)
        case let (_, _, minute, _) where minute > 0:
            return StringResource.minute.localizedFormat(minute)
        default:
            let seconds = max(components.second ?? 0, 1)
            return StringResource.second.localizedFormat(seconds)
        }
    }

    var daysPassedSinceNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
}

// MARK: - Constants

private extension Date {

    enum StringResource: String.LocalizationValue {
        case day = "elapsed_day"
        case hour = "elapsed_hour"
        case minute = "elapsed_minute"
        case second = "elapsed_second"

        func localizedFormat(_ args: CVarArg...) -> String {
            let format = String(localized: rawValue)
            return String(format: format, arguments: args)
        }
    }
}
