
import Foundation
import Combine
import SwiftUI

final class Store<Value, Action>: ObservableObject {
    var reducer: (inout Value, Action) -> Void
    @Published private(set) var value: Value
    private var cancellable: Cancellable?
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action: Action) {
        reducer(&self.value, action)
    }
   
    func view<LocalValue, LocalAction>(
        _ f: @escaping (Value) -> LocalValue,
        _ g: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: f(self.value),
            reducer: { localValue, localAction in
                self.send(g(localAction))
                localValue = f(self.value)
        })
        
        localStore.cancellable = self.$value.sink { [weak localStore] newValue in
          localStore?.value = f(newValue)
        }

        return localStore
    }
}

extension Store {
    public func send(_ actions: [Action]) {
        actions.forEach { self.send($0) }
    }
    
    func send(actionFunctions: [(Value) -> Action?]) {
        for af in actionFunctions {
            if let action = af(value) {
                send(action)
            }
        }
    }
}

extension Store {
    public func send<LocalValue>(
        _ action: @escaping (LocalValue) -> Action,
        getValue: @escaping (Value) -> LocalValue
    ) -> Binding<LocalValue> {
        Binding(
            get: { getValue(self.value) },
            set: { self.send(action($0)) }
        )
    }
}




