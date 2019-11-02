import Foundation
import Combine
import SwiftUI

typealias StoreEffect<Action> = () -> Action?
typealias Reducer<Value, Action> = (inout Value, Action) -> [StoreEffect<Action>]

final class Store<Value, Action>: ObservableObject {
    var reducer: Reducer<Value, Action>
    @Published private(set) var value: Value
    private var cancellable: Cancellable?
    
    init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action: Action) {
        let effects = reducer(&self.value, action)
        effects.forEach { effect in
            if let action = effect() {
                send(action)
            }
        }
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
                return []
        })
        
        localStore.cancellable = self.$value.sink { [weak localStore] newValue in
          localStore?.value = f(newValue)
        }

        return localStore
    }
    
    func optionalView<LocalValue, LocalAction>(
        _ f: @escaping (Value) -> LocalValue?,
        _ g: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction>? {
        
        if let substate = f(self.value) {
            let localStore = Store<LocalValue, LocalAction>(
                initialValue: substate,
                reducer: { localValue, localAction in
                    self.send(g(localAction))
                    localValue = substate
                    return []
            })
            
            localStore.cancellable = self.$value.sink { [weak localStore] newValue in
              localStore?.value = substate
            }

            return localStore
        }
        
        return nil
    }
}

func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    { value, action in reducers.flatMap { $0(&value, action) } }
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
        _ getValue: @escaping (Value) -> LocalValue,
        _ action: @escaping (LocalValue) -> Action
        
    ) -> Binding<LocalValue> {
        .init(
            get: { getValue(self.value) },
            set: { self.send(action($0)) }
        )
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return [] }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)
        return localEffects.map { localEffect in
            { () -> GlobalAction? in
                guard let localAction = localEffect() else { return nil }
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                return globalAction
            }
        }
    }
}

