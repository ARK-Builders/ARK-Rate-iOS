protocol CurrencyRemoteDataSource {

    func fetch() async throws -> [CurrencyDTO]
}
