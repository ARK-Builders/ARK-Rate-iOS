import SwiftUI

typealias Frames = [Int: CGRect]
typealias ButtonAction = () -> Void
typealias ActionHandler<T> = (T) -> Void
typealias ReorderingAction = (Int, Int) -> Void
typealias Reorderable = Identifiable & Equatable
typealias TitleSubtitlePair = (title: String, subtitle: String)
typealias ButtonConfiguration = (title: String, action: ButtonAction)
