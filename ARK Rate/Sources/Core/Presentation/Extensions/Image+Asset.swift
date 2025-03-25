import SwiftUI

extension Image {

    // MARK: - Properties

    private static let cacheQueue = DispatchQueue(label: "assets_cache_access_queue", attributes: .concurrent)
    private static var _cache = [String: Bool]()
    private static var cache: [String: Bool] {
        get { cacheQueue.sync { _cache } }
        set { cacheQueue.async(flags: .barrier) { _cache = newValue } }
    }

    // MARK: - Methods

    static func image(
        _ name: String,
        fallback: ImageResource = ImageResource.earth
    ) -> Image {
        let result: (Bool) -> Image = { $0 ? Image(name) : Image(fallback) }
        if let cached = cache[name] {
            return result(cached)
        }
        let exists = UIImage(named: name) != nil
        cache[name] = exists
        return result(exists)
    }
}
