import Foundation

extension Date {

    // MARK: - Properties

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    var formattedElapsedTime: String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        if let days = components.day, days >= 4 {
            return Date.formatter.string(from: self)
        }
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
            let seconds = components.second ?? 0
            return StringResource.second.localizedFormat(seconds)
        }
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
