import Foundation

enum AppConfig {

    static let fiatRateUrl: String = {
        Bundle.main.getValue(from: "Fiat Rates URL")!
    }()

    static let cryptoRatesUrl: String = {
        Bundle.main.getValue(from: "Crypto Rates URL")!
    }()
}
