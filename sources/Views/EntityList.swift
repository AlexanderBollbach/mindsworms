import SwiftUI

struct EntityList<E: Identifiable & Selectable & Titled, Action>: View {
    let name: String
    let emptyMessage: String
    @ObservedObject var store: Store<[E], ListAction<E, Action, E.ID>>
    var body: some View {
        Group {
            if store.value.isEmpty {
                Text(emptyMessage)
                    .modifier(PrimaryLabel())
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(store.value.enumerated()), id: \.element.id) { val in
                            Button(val.element.title) {
                                self.store.send(.deselectAll)
                                self.store.send(.select(id: val.element.id))
                            }
                            .buttonStyle(ButtonStyleText2(isSelected: val.element.isSelected))
                            .frame(maxHeight: .infinity)
                        }
                        .animation(.default)
                    }
                }
            }
        }
    }
}
