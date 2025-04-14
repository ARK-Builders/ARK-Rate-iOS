import Foundation

struct MetadataRepositoryImpl: MetadataRepository {

    // MARK: - Properties

    let userDefaults: UserDefaults

    // MARK: - Conformance

    func recordCurrenciesFetchDate() {
        userDefaults.set(Date(), forKey: Keys.currenciesFetchDate.rawValue)
    }

    func lastCurrenciesFetchDate() -> Date? {
        userDefaults.object(forKey: Keys.currenciesFetchDate.rawValue) as? Date
    }
}

// MARK: - Constants

private extension MetadataRepositoryImpl {

    enum Keys: String {
        case currenciesFetchDate
    }
}
