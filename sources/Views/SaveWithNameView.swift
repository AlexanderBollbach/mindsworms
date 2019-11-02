import SwiftUI

struct SaveWithNameView: View {
    let message: String
    let initialValue: String
    
    @State private var text: String = ""
    
    let onFinish: (String) -> Void
    
    init(message: String = "--", initialValue: String, onFinish: @escaping (String) -> Void) {
        self.message = message
        self.onFinish = onFinish
        self.initialValue = initialValue
    }
    
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text(self.message).modifier(PrimaryLabel())
            TextField("\(self.message): ", text: self.$text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("done") {
                self.onFinish(self.text)
            }
            .buttonStyle(ButtonStyleText())
        }
        .padding(style.spacing.large).onAppear() {
            self.text = self.initialValue
        }
    }
}
