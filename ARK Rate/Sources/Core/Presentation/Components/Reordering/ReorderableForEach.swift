import SwiftUI
import IdentifiedCollections

struct ReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {

    // MARK: - Properties

    private let items: IdentifiedArrayOf<Item>
    private let content: (Item) -> Content
    private let preview: (Item) -> Preview
    private let reorderingAction: (Item, Item) -> Void

    @Binding private var isDragging: Bool
    @Binding private var draggingItem: Item?

    // MARK: - Initialization

    init(
        _ items: IdentifiedArrayOf<Item>,
        isDragging: Binding<Bool>,
        draggingItem: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder preview: @escaping (Item) -> Preview,
        reorderingAction: @escaping (Item, Item) -> Void
    ) {
        self.items = items
        self._isDragging = isDragging
        self._draggingItem = draggingItem
        self.content = content
        self.preview = preview
        self.reorderingAction = reorderingAction
    }

    // MARK: - Body

    var body: some View {
        ForEach(items) { item in
            content(item)
            .contentShape(Rectangle())
            .onDrag {
                draggingItem = item
                return NSItemProvider(object: "\(item.id)" as NSString)
            }
            preview: { preview(item) }
            .onDrop(
                of: [.plainText],
                delegate: HoverDropDelegate(
                    onHovering: {
                        guard let draggingItem, item != draggingItem else { return }
                        isDragging = true
                        reorderingAction(draggingItem, item)
                    },
                    onDropCompleted: {
                        isDragging = false
                        draggingItem = nil
                    }
                )
            )
            .isHidden(isDragging && item == draggingItem)
        }
    }
}
