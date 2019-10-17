import SwiftUI
//
//struct EffectsCommandsView: View {
//    
//    let availableEffects: [Effect]
//    let send: (EffectsAction) -> Void
//    
//    @State private var showModal_AddEffect: Bool = false
//    @State private var showModal_SavePreset: Bool = false
//    
//    @EnvironmentObject var style: Style
//    
//    var body: some View {
//        
//        HStack {
//            ItemView(title: "+") {
//                self.showModal_AddEffect = true
//            }
//            ItemView(title: "-") {
//                self.send(.deleteSelected)
//            }
//            .sheet(isPresented: $showModal_AddEffect) {
//                AddEffectsView(effects: self.availableEffects) { effect in
//                    self.send(.add(effect))
//                    self.send(.selectOnly(id: effect.id))
//                }
//                .environment(\.colorScheme, .dark)
//                .environmentObject(self.style)
//            }
//            
//            
//            ItemView(title: "save preset") {
//                self.showModal_SavePreset = true
//            }
//            .sheet(isPresented: $showModal_SavePreset) {
//                SavePresetView() { name in
//                    print(name)
//                }
//            }
//                .environment(\.colorScheme, .dark)
//                .environmentObject(self.style)
//        }
//    }
//}
//
//
//private struct AddEffectsView: View {
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    let effects: [Effect]
//    let didSelect: (Effect) -> Void
//    
//    var body: some View {
//        VStack {
//            ForEach(effects) { effect in
//                ItemView(title: effect.name) {
//                    self.presentationMode.wrappedValue.dismiss()
//                    self.didSelect(effect)
//                }
//            }
//        }.background(Color.black)
//    }
//}
//
//private struct SavePresetView: View {
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State var text: String = ""
//    
//    let didSave: (String) -> Void
//    
//    var body: some View {
//        VStack {
//            TextField("", text: $text)
//            Button(action: { self.didSave(self.text) }) {
//                Text("save")
//            }
//        }.background(Color.black)
//    }
//}
