import Foundation

extension Decimal {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    var formattedRate: String {
        return Decimal.formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}
