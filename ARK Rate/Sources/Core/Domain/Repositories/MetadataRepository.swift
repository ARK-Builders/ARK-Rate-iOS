import Foundation

protocol MetadataRepository {

    func recordCurrenciesFetchDate()
    func lastCurrenciesFetchDate() -> Date?
}
