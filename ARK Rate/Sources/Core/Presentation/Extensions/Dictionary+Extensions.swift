extension Dictionary where Value: Equatable {

    func keys(forValue value: Value) -> [Key] {
        self
            .filter { $0.value == value }
            .map { $0.key }
    }
}
