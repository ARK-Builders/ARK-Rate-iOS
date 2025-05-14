import Foundation

extension Decimal {

    // MARK: - Properties

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    var formattedRate: String {
        let fractionSize = self > Decimal(10) ? 2 : 8
        Decimal.formatter.maximumFractionDigits = fractionSize
        return Decimal.formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }

    // MARK: - Methods

    func divideArk(
        _ divisor: Decimal,
        scale: Int = 50,
        roundingMode: NSDecimalNumber.RoundingMode = .bankers
    ) -> Decimal {
        var result = Decimal()
        var dividend = self
        var divisor = divisor
        NSDecimalDivide(&result, &dividend, &divisor, roundingMode)
        var roundedResult = Decimal()
        NSDecimalRound(&roundedResult, &result, scale, roundingMode)
        return roundedResult
    }
}

// MARK: -

extension Decimal {

    static func from(_ amount: String, default defaultValue: Decimal = 0) -> Decimal {
        Decimal(string: amount.replacingOccurrences(of: ",", with: ".")) ?? defaultValue
    }
}
