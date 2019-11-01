import SwiftUI

struct AttributesView: View {
    @ObservedObject var store: Store<[Attribute], AttributesAction>
    
    var body: some View {
        return HStack {
            if store.value.isEmpty {
                Text("no active attributes")
                    .modifier(PrimaryLabel())
            } else {
                HStack {
                    ForEach(store.value) { attribute in
                        MySlider(title: attribute.name, amount: attribute.value) {
                            self.store.send(.update(attribute.id, .changeValue($0)))
                        }
                    }
                }
            }
        }
    }
}

