typealias ButtonAction = () -> Void
typealias SelectedAction<T> = (T) -> Void
typealias TitleSubtitlePair = (title: String, subtitle: String)
typealias ButtonConfiguration = (title: String, action: ButtonAction)
